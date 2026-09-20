#!/usr/bin/env python3
"""One-off migration of this site's content from microCMS into koya.

Reads MICROCMS_SERVICE_DOMAIN / MICROCMS_API_KEY and KOYA_URL / KOYA_SECRET from
the environment (or .env) and creates published contents in koya keeping the
original ids, publish dates and richtext HTML.

    python3 scripts/import-from-microcms.py [--dry-run] [--replace]

--replace deletes contents that already exist in koya and creates them again,
so every system timestamp (createdAt, updatedAt, publishedAt, revisedAt) is
taken from microCMS.

Images embedded in richtext (<img src="https://images.microcms-assets.io/...">)
are downloaded, uploaded to koya's media library and the src rewritten to the
koya /media/ path. A file already in the library under the same name is reused,
so re-running does not duplicate images.
"""
import json, os, re, sys, urllib.parse, urllib.request, urllib.error, uuid


def load_dotenv(path=".env"):
    if os.path.exists(path):
        for line in open(path):
            line = line.strip()
            if line and not line.startswith("#") and "=" in line:
                k, v = line.split("=", 1)
                os.environ.setdefault(k, v)


def env(name):
    v = os.environ.get(name)
    if not v:
        sys.exit(f"{name} is not set")
    return v


def parse_body(raw):
    """JSON when it is JSON; otherwise the text, so an HTML error page from a proxy is readable."""
    try:
        return json.loads(raw or b"{}")
    except json.JSONDecodeError:
        return {"raw": raw.decode(errors="replace")[:300]}


def http(method, url, headers, body=None):
    data = json.dumps(body).encode() if body is not None else None
    # Cloudflare in front of koya rejects urllib's default User-Agent (error 1010)
    req = urllib.request.Request(url, data=data, method=method,
                                 headers={**headers, "Content-Type": "application/json", "User-Agent": USER_AGENT})
    try:
        with urllib.request.urlopen(req) as res:
            return res.status, parse_body(res.read())
    except urllib.error.HTTPError as e:
        return e.code, parse_body(e.read())


def multipart(fields, files):
    """Encode FIELDS {name: value} and FILES [(name, filename, content_type, bytes)]."""
    boundary = "----koya" + uuid.uuid4().hex
    out = bytearray()
    for name, value in fields.items():
        out += f"--{boundary}\r\nContent-Disposition: form-data; name=\"{name}\"\r\n\r\n{value}\r\n".encode()
    for name, filename, content_type, data in files:
        out += (f"--{boundary}\r\nContent-Disposition: form-data; name=\"{name}\"; filename=\"{filename}\"\r\n"
                f"Content-Type: {content_type}\r\n\r\n").encode()
        out += data + b"\r\n"
    out += f"--{boundary}--\r\n".encode()
    return bytes(out), f"multipart/form-data; boundary={boundary}"


USER_AGENT = "koya-import/1.0"

IMG_SRC = re.compile(r'(<img\b[^>]*?\bsrc=")(https://images\.microcms-assets\.io/[^"]+)(")')


def make_image_migrator(koya_media, koya_headers, dry):
    """Return rewrite(html) -> html with microCMS image URLs replaced by koya media paths."""
    cache = {}  # source URL -> koya path

    def library_path_for(filename):
        status, res = http("GET", f"{koya_media}?q={urllib.parse.quote(filename)}&limit=100", koya_headers)
        if status != 200:
            return None
        for m in res.get("media", []):
            if m["filename"] == filename:
                return urllib.parse.urlparse(m["url"]).path
        return None

    def migrate(url):
        if url in cache:
            return cache[url]
        filename = urllib.parse.unquote(urllib.parse.urlparse(url).path.rsplit("/", 1)[-1]) or "image"
        path = library_path_for(filename)
        if path:
            print(f"    reuse  {filename}")
        elif dry:
            print(f"    would upload {filename}")
            path = None
        else:
            try:
                with urllib.request.urlopen(urllib.request.Request(url, headers={"User-Agent": USER_AGENT})) as res:
                    data, content_type = res.read(), res.headers.get("Content-Type", "application/octet-stream")
            except urllib.error.URLError as e:
                print(f"    FAILED download {url}: {e}")
                cache[url] = None
                return None
            body, ctype = multipart({}, [("file", filename, content_type, data)])
            req = urllib.request.Request(koya_media, data=body, method="POST",
                                         headers={**koya_headers, "Content-Type": ctype, "User-Agent": USER_AGENT})
            try:
                with urllib.request.urlopen(req) as res:
                    uploaded = json.loads(res.read())["media"][0]
                path = urllib.parse.urlparse(uploaded["url"]).path
                print(f"    upload {filename} -> {path}")
            except urllib.error.HTTPError as e:
                print(f"    FAILED upload {filename}: {e.code} {e.read().decode(errors='replace')}")
                path = None
        cache[url] = path
        return path

    def rewrite(html):
        def repl(match):
            path = migrate(match.group(2))
            # keep the microCMS URL when the image could not be moved
            return match.group(1) + (path or match.group(2)) + match.group(3)
        return IMG_SRC.sub(repl, html or "")

    return rewrite


def main():
    load_dotenv()
    dry = "--dry-run" in sys.argv
    replace = "--replace" in sys.argv
    mc = f"https://{env('MICROCMS_SERVICE_DOMAIN')}.microcms.io/api/v1"
    mc_headers = {"X-MICROCMS-API-KEY": env("MICROCMS_API_KEY")}
    koya = env("KOYA_URL").rstrip("/") + "/admin/api/contents/website"
    print(f"koya: {env('KOYA_URL')} (environment variables win over .env)")
    koya_headers = {"Authorization": f"Bearer {env('KOYA_SECRET')}"}
    rewrite_images = make_image_migrator(env("KOYA_URL").rstrip("/") + "/admin/api/media/website", koya_headers, dry)

    TIMESTAMPS = ("createdAt", "updatedAt", "publishedAt", "revisedAt")

    def timestamps(item):
        return {k: item[k] for k in TIMESTAMPS if item.get(k)}

    def existing_ids(model):
        status, res = http("GET", f"{koya}/{model}?limit=100", koya_headers)
        if status != 200:
            sys.exit(f"koya {model}: {status} {res}")
        return [c["id"] for c in res["contents"]]

    def delete(model, cid):
        status, res = http("DELETE", f"{koya}/{model}/{cid}", koya_headers)
        if status != 200:
            sys.exit(f"koya delete {model}/{cid}: {status} {res}")

    def upsert(model, payload, current_ids):
        cid = payload.get("id")
        label = f"{model}/{cid or '(object)'}"
        # Object models have one content whatever its id; list models match by id.
        stale = current_ids if cid is None else [i for i in current_ids if i == cid]
        if stale and not replace:
            print(f"  skipped {label} (already exists; use --replace)")
            return
        if dry:
            print(f"  would {'replace' if stale else 'import'} {label}")
            return
        for old in stale:
            delete(model, old)
        status, res = http("POST", f"{koya}/{model}", koya_headers, payload)
        if status == 201:
            print(f"  {'replaced' if stale else 'created'} {label}")
        else:
            print(f"  FAILED {label}: {status} {res}")

    print("blog")
    status, res = http("GET", f"{mc}/blog?limit=100&fields=id,title,description,content,"
                       + ",".join(TIMESTAMPS), mc_headers)
    if status != 200:
        sys.exit(f"microCMS blog: {status} {res}")
    blog_ids = existing_ids("blog")
    for item in res["contents"]:
        upsert("blog", {
            "id": item["id"],
            "publish": True,
            **timestamps(item),
            "data": {
                "title": item["title"],
                "description": item.get("description", ""),
                "content": rewrite_images(item.get("content", "")),
            },
        }, blog_ids)

    for model in ("about", "works"):
        print(model)
        status, res = http("GET", f"{mc}/{model}", mc_headers)
        if status != 200:
            sys.exit(f"microCMS {model}: {status} {res}")
        upsert(model, {"publish": True, **timestamps(res),
                       "data": {"content": rewrite_images(res.get("content", ""))}}, existing_ids(model))


if __name__ == "__main__":
    main()
