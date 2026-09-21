# website

My personal website — [skyizwhite.dev](https://skyizwhite.dev)

A server-rendered personal site written in Common Lisp. Client-side interactivity and partial page updates are handled by [Nomini](https://nomini.js.org/).

The site is built to load fast and to pick up content edits quickly. Pages are served from a CDN with stale-while-revalidate, so visitors get a cached response instantly. When content is published in the headless CMS, a webhook invalidates only the affected pages and data, and the CDN picks up the change on its next revalidation, with no redeploy or full cache purge.

## Tech Stack

| Layer | Choice |
| --- | --- |
| Language | [Common Lisp](https://common-lisp.net/) ([SBCL](https://www.sbcl.org/)) |
| Dependency manager | [Qlot](https://github.com/fukamachi/qlot) |
| Web stack | [Clack](https://github.com/fukamachi/clack) / [Lack](https://github.com/fukamachi/lack) on [Woo](https://github.com/fukamachi/woo) |
| Routing | [jingle](https://github.com/dnaeon/cl-jingle) with [ningle-fbr](https://github.com/skyizwhite/ningle-fbr) for file-based routing |
| Fragment endpoints | [ningle-actions](https://github.com/skyizwhite/ningle-actions) |
| Templating | [HSX](https://github.com/skyizwhite/hsx) |
| Content | [koya](https://github.com/skyizwhite/koya) (self-hosted headless CMS) via its Lisp client |
| Like counts | [Redis](https://redis.io/) via [cl-redis](https://github.com/vseloved/cl-redis) |
| Styling | [Tailwind CSS](https://tailwindcss.com/) v4 |
| Interactivity | [Nomini](https://nomini.js.org/) |
| Infrastructure | [Cloudflare](https://www.cloudflare.com/) CDN, [Coolify](https://coolify.io/), [Docker](https://www.docker.com/) |

## Content schema

The koya content models live in `src/schema.lisp` (definitions only). The REPL commands that talk to the server are in `src/koya.lisp`. Copy `.env.example` to `.env`, set `KOYA_URL` and a `KOYA_MANAGEMENT_KEY` made on koya's Settings page, then:

```lisp
(ql:quickload :website/koya)
(website/koya:plan)             ; diff the local models against the server
(website/koya:deploy)           ; apply it, asking before destructive changes
(website/koya:deploy :force t)  ; apply destructive changes without asking
(website/koya:pull)             ; the schema currently on the server
(website/koya:webhook-secret)   ; the value to put in KOYA_WEBHOOK_KEY
```

In production the container does this itself: `docker/entrypoint.sh` runs `(website/koya:deploy-at-startup)`, a forced deploy of `src/schema.lisp`, before starting the server, so the schema on koya always matches the code that is running. Destructive changes are applied without a prompt, so review `plan` against production before deploying a schema change. If koya is unreachable at start, the deploy is logged and skipped.
