#!/usr/bin/env python3
"""One-off migration of this site's content from microCMS into koya.

Reads MICROCMS_SERVICE_DOMAIN / MICROCMS_API_KEY and KOYA_URL / KOYA_SECRET from
the environment (or .env), converts richtext HTML to Markdown with markdownify,
and creates published contents in koya keeping the original ids and publish dates.

    pip install markdownify
    python3 scripts/import-from-microcms.py [--dry-run]
"""
import json, os, sys, urllib.request, urllib.error

try:
    from markdownify import markdownify
except ImportError:
    sys.exit("pip install markdownify")


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


def http(method, url, headers, body=None):
    data = json.dumps(body).encode() if body is not None else None
    req = urllib.request.Request(url, data=data, method=method, headers={**headers, "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req) as res:
            return res.status, json.loads(res.read() or b"{}")
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read() or b"{}")


def to_markdown(html):
    return markdownify(html or "", heading_style="ATX", bullets="-").strip() + "\n"


def main():
    load_dotenv()
    dry = "--dry-run" in sys.argv
    mc = f"https://{env('MICROCMS_SERVICE_DOMAIN')}.microcms.io/api/v1"
    mc_headers = {"X-MICROCMS-API-KEY": env("MICROCMS_API_KEY")}
    koya = env("KOYA_URL").rstrip("/") + "/admin/api/contents/website"
    koya_headers = {"Authorization": f"Bearer {env('KOYA_SECRET')}"}

    def create(model, payload):
        if dry:
            print(f"  would create {model}/{payload.get('id', '(new)')}")
            return
        status, res = http("POST", f"{koya}/{model}", koya_headers, payload)
        if status == 201:
            print(f"  created {model}/{res['id']}")
        elif status == 409:
            print(f"  skipped {model}/{payload['id']} (already exists)")
        else:
            print(f"  FAILED {model}: {status} {res}")

    print("blog")
    status, res = http("GET", f"{mc}/blog?limit=100&fields=id,title,description,content,publishedAt", mc_headers)
    if status != 200:
        sys.exit(f"microCMS blog: {status} {res}")
    for item in res["contents"]:
        create("blog", {
            "id": item["id"],
            "publish": True,
            "publishedAt": item["publishedAt"],
            "data": {
                "title": item["title"],
                "description": item.get("description", ""),
                "content": to_markdown(item.get("content", "")),
            },
        })

    for model in ("about", "works"):
        print(model)
        status, res = http("GET", f"{mc}/{model}", mc_headers)
        if status != 200:
            sys.exit(f"microCMS {model}: {status} {res}")
        create(model, {
            "publish": True,
            "publishedAt": res["publishedAt"],
            "data": {"content": to_markdown(res.get("content", ""))},
        })


if __name__ == "__main__":
    main()
