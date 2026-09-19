#!/usr/bin/env python3
"""Slice the source woff2 fonts by unicode-range and emit @font-face CSS.

Usage: python3 fonts/slice.py   (requires fonttools[woff])
"""
from __future__ import annotations

import hashlib
import io
import shutil
import sys
import tempfile
from pathlib import Path

from fontTools import subset
from fontTools.pens.recordingPen import RecordingPen
from fontTools.ttLib import TTFont

ROOT = Path(__file__).resolve().parent.parent
SRC_DIR = ROOT / "fonts"
OUT_DIR = ROOT / "assets" / "fonts"
CSS_DIR = ROOT / "assets" / "style"
CSS_GLOB = "fonts-*.css"
RANGES_FILE = SRC_DIR / "unicode-ranges.txt"

FAMILY = "LINE Seed JP"
SOURCES = [
    ("LINESeedJP-Regular.woff2", 400),
    ("LINESeedJP-Bold.woff2", 700),
    ("LINESeedJP-ExtraBold.woff2", 800),
]
PRELOAD = [(400, "あ"), (400, "A"), (700, "あ"), (700, "A"), (800, "A")]
PRELOAD_FILE = "preload.txt"
ATTEMPTS = 5


def parse_range(spec: str) -> set[int]:
    cps: set[int] = set()
    for tok in spec.split(","):
        tok = tok.strip()
        if not tok:
            continue
        tok = tok[2:] if tok.upper().startswith("U+") else tok
        if "-" in tok:
            lo, hi = tok.split("-")
            cps.update(range(int(lo, 16), int(hi, 16) + 1))
        else:
            cps.add(int(tok, 16))
    return cps


def format_range(cps: set[int]) -> str:
    out: list[str] = []
    seq = sorted(cps)
    i = 0
    while i < len(seq):
        j = i
        while j + 1 < len(seq) and seq[j + 1] == seq[j] + 1:
            j += 1
        out.append(f"U+{seq[i]:04X}" if i == j else f"U+{seq[i]:04X}-{seq[j]:04X}")
        i = j + 1
    return ",".join(out)


def load_ranges() -> list[str]:
    return [l.strip() for l in RANGES_FILE.read_text().splitlines() if l.strip()]


def open_font(data: Path | bytes) -> TTFont:
    stream = io.BytesIO(data) if isinstance(data, bytes) else data
    return TTFont(stream, recalcTimestamp=False, recalcBBoxes=False)


def decode(src: Path) -> bytes:
    font = open_font(src)
    font.flavor = None
    buf = io.BytesIO()
    font.save(buf)
    return buf.getvalue()


def outlines(font: TTFont, cps: set[int] | None = None) -> dict[int, list]:
    glyphs = font.getGlyphSet()
    result: dict[int, list] = {}
    for cp, name in font.getBestCmap().items():
        if cps is None or cp in cps:
            pen = RecordingPen()
            glyphs[name].draw(pen)
            result[cp] = pen.value
    return result


def subset_font(ttf: bytes, cps: set[int], reference: dict[int, list]) -> tuple[bytes, set[int]] | None:
    keep = cps & set(open_font(ttf).getBestCmap())
    if not keep:
        return None
    for attempt in range(1, ATTEMPTS + 1):
        font = open_font(ttf)
        opts = subset.Options()
        opts.layout_features = ["*"]
        opts.name_IDs = ["*"]
        opts.notdef_outline = True
        subsetter = subset.Subsetter(options=opts)
        subsetter.populate(unicodes=keep)
        subsetter.subset(font)
        font.flavor = "woff2"
        out = io.BytesIO()
        font.save(out)
        data = out.getvalue()
        broken = [cp for cp, value in outlines(open_font(data)).items() if value != reference[cp]]
        if not broken:
            return data, keep
        print(
            f"warning: attempt {attempt} produced a wrong outline for "
            f"{', '.join(f'U+{cp:04X}' for cp in broken[:5])}; retrying",
            file=sys.stderr,
        )
    raise RuntimeError(f"could not produce an intact slice for {format_range(keep)[:60]}...")


def main() -> None:
    ranges = load_ranges()
    slices = [parse_range(r) for r in ranges]

    decoded = {name: decode(SRC_DIR / name) for name, _ in SOURCES}

    covered: set[int] = set().union(*slices)
    rest: set[int] = set()
    for ttf in decoded.values():
        rest |= set(open_font(ttf).getBestCmap()) - covered
    if rest:
        print(
            f"warning: {len(rest)} codepoints not in {RANGES_FILE.name}, "
            f"emitting them as slice {len(slices)}: {format_range(rest)}",
            file=sys.stderr,
        )
        slices.append(rest)

    tmp_dir = Path(tempfile.mkdtemp(prefix=".fonts-", dir=OUT_DIR.parent))
    try:
        css, built = build_slices(decoded, slices, tmp_dir)
        (tmp_dir / PRELOAD_FILE).write_text("".join(f"{url}\n" for url in preload_urls(built)))
    except BaseException:
        shutil.rmtree(tmp_dir, ignore_errors=True)
        raise

    css_text = "\n".join(css)
    css_out = CSS_DIR / f"fonts-{hashlib.sha256(css_text.encode()).hexdigest()[:8]}.css"

    if OUT_DIR.exists():
        shutil.rmtree(OUT_DIR)
    tmp_dir.rename(OUT_DIR)
    for stale in CSS_DIR.glob(CSS_GLOB):
        stale.unlink()
    css_out.write_text(css_text)

    total = sum(p.stat().st_size for p in OUT_DIR.glob("*.woff2"))
    print(f"{len(list(OUT_DIR.glob('*.woff2')))} slices, {total / 1024:.0f} KiB total -> {css_out.relative_to(ROOT)}")


def build_slices(
    decoded: dict[str, bytes], slices: list[set[int]], out_dir: Path
) -> tuple[list[str], list[tuple[int, set[int], str]]]:
    css: list[str] = ["/* generated by fonts/slice.py; do not edit */"]
    built: list[tuple[int, set[int], str]] = []
    for name, weight in SOURCES:
        stem = Path(name).stem
        reference = outlines(open_font(decoded[name]))
        for idx, cps in enumerate(slices):
            result = subset_font(decoded[name], cps, reference)
            if result is None:
                continue
            data, keep = result
            digest = hashlib.sha256(data).hexdigest()[:8]
            out_name = f"{stem}.{idx}.{digest}.woff2"
            (out_dir / out_name).write_bytes(data)
            built.append((weight, keep, f"/assets/fonts/{out_name}"))
            css.append(
                "@font-face{"
                f"font-family:'{FAMILY}';font-style:normal;font-weight:{weight};font-display:swap;"
                f"src:url(/assets/fonts/{out_name}) format('woff2');"
                f"unicode-range:{format_range(keep)}"
                "}"
            )
    return css, built


def preload_urls(built: list[tuple[int, set[int], str]]) -> list[str]:
    urls: list[str] = []
    for weight, ch in PRELOAD:
        matches = [url for w, keep, url in built if w == weight and ord(ch) in keep]
        if not matches:
            print(f"warning: no {weight} slice covers {ch!r}; not preloaded", file=sys.stderr)
            continue
        urls.append(matches[-1])
    return urls


if __name__ == "__main__":
    main()
