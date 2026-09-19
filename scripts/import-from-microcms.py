#!/usr/bin/env python3
"""One-off migration of this site's content from microCMS into koya.

Reads MICROCMS_SERVICE_DOMAIN / MICROCMS_API_KEY and KOYA_URL / KOYA_SECRET from
the environment (or .env) and creates published contents in koya keeping the
original ids, publish dates and richtext HTML.

    python3 scripts/import-from-microcms.py [--dry-run] [--replace]

--replace re-publishes contents that already exist in koya.
"""
import json, os, sys, urllib.request, urllib.error


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
    req = urllib.request.Request(url, data=data, method=method,
                                 headers={**headers, "Content-Type": "application/json"})
    try:
        with urllib.request.urlopen(req) as res:
            return res.status, json.loads(res.read() or b"{}")
    except urllib.error.HTTPError as e:
        return e.code, json.loads(e.read() or b"{}")


def main():
    load_dotenv()
    dry = "--dry-run" in sys.argv
    replace = "--replace" in sys.argv
    mc = f"https://{env('MICROCMS_SERVICE_DOMAIN')}.microcms.io/api/v1"
    mc_headers = {"X-MICROCMS-API-KEY": env("MICROCMS_API_KEY")}
    koya = env("KOYA_URL").rstrip("/") + "/admin/api/contents/website"
    koya_headers = {"Authorization": f"Bearer {env('KOYA_SECRET')}"}

    def upsert(model, payload):
        label = f"{model}/{payload.get('id', '(object)')}"
        if dry:
            print(f"  would import {label}")
            return
        status, res = http("POST", f"{koya}/{model}", koya_headers, payload)
        if status == 201:
            print(f"  created {label}")
        elif status == 409 and replace:
            status, res = http("POST", f"{koya}/{model}/{payload['id']}/publish", koya_headers,
                               {"data": payload["data"], "publishedAt": payload["publishedAt"]})
            print(f"  {'replaced' if status == 200 else 'FAILED'} {label} {'' if status == 200 else res}")
        elif status == 409:
            print(f"  skipped {label} (already exists; use --replace)")
        else:
            print(f"  FAILED {label}: {status} {res}")

    print("blog")
    status, res = http("GET", f"{mc}/blog?limit=100&fields=id,title,description,content,publishedAt", mc_headers)
    if status != 200:
        sys.exit(f"microCMS blog: {status} {res}")
    for item in res["contents"]:
        upsert("blog", {
            "id": item["id"],
            "publish": True,
            "publishedAt": item["publishedAt"],
            "data": {
                "title": item["title"],
                "description": item.get("description", ""),
                "content": item.get("content", ""),
            },
        })

    for model in ("about", "works"):
        print(model)
        status, res = http("GET", f"{mc}/{model}", mc_headers)
        if status != 200:
            sys.exit(f"microCMS {model}: {status} {res}")
        # object models are upserted by the server
        upsert(model, {"publish": True, "publishedAt": res["publishedAt"],
                       "data": {"content": res.get("content", "")}})


if __name__ == "__main__":
    main()
