# website

My personal website — [skyizwhite.dev](https://skyizwhite.dev)

A server-rendered site built in **Common Lisp**, sourcing content from a headless CMS and serving HTML with Next.js-style caching semantics behind a CDN.

## Tech Stack

| Layer | Choice |
| --- | --- |
| Language | Common Lisp (SBCL) |
| Dependency manager | [qlot](https://github.com/fukamachi/qlot) |
| Web stack | [Clack](https://github.com/fukamachi/clack) / [Lack](https://github.com/fukamachi/lack) |
| HTTP server | [Woo](https://github.com/fukamachi/woo) (production), Hunchentoot (development) |
| Routing framework | [jingle](https://github.com/dnaeon/cl-jingle) + [ningle-fbr](https://github.com/skyizwhite/ningle-fbr) (file-based routing) |
| View / templating | [hsx](https://github.com/skyizwhite/hsx) — JSX-like HTML as Lisp s-expressions |
| Content | [microCMS](https://microcms.io/) via [microcms-lisp-sdk](https://github.com/skyizwhite/microcms-lisp-sdk) |
| Caching | [function-cache](https://github.com/AccelerationNet/function-cache) (in-memory) + HTTP `Cache-Control` |
| Styling | [Tailwind CSS](https://tailwindcss.com/) v4 (standalone binary) |
| Interactivity | [Alpine.js](https://alpinejs.dev/) (CDN) |
| CDN | Cloudflare |
| Task runner | [just](https://github.com/casey/just) |
| Deployment | [Coolify](https://coolify.io/) (Docker) |

## Architecture

```
Cloudflare (CDN)
      │
      ▼
  Woo (HTTP server)
      │
  Lack middleware  ── accesslog, trailing-slash, error pages, /assets static
      │
  ┌───┴─────────────────────────┐
  │                             │
*page-app*  (HTML)         *api-app*  (JSON, mounted at /api)
  │                             │
  ▼                             ▼
~document → hsx render     revalidate webhook
  │
  ▼
microCMS  ←─ function-cache (memoized fetches)
```

- **Package-inferred system.** Each file is its own package (`:class :package-inferred-system`); dependencies are resolved from `import-from` clauses.
- **File-based routing.** `ningle-fbr` maps files under `src/pages/` to HTML routes and `src/api/` to JSON routes. A file exporting `@get` / `@head` / `@post` becomes a handler; `<id>.lisp` is a dynamic segment.
- **Two sub-apps.** `*page-app*` wraps every result in `~document` and renders it to an HTML string; `*api-app*` serializes results to JSON and is mounted under `/api`.
- **CMS-backed content.** `src/lib/cms.lisp` fetches `about`, `works`, and `blog` content from microCMS. Calls are memoized with `function-cache`.
- **Next.js-style cache control.** `set-cache` (in `src/helper.lisp`) sets `Cache-Control` per page using one of three strategies:
  - `:ssr` — always revalidate (`max-age=0, must-revalidate`)
  - `:isr` — incremental static regeneration (`s-maxage=60, stale-while-revalidate`)
  - `:sg`  — static generation (`s-maxage=1yr`)
  - In dev mode all responses are `no-store`.
- **On-demand revalidation.** A microCMS webhook hits `POST /api/revalidate` (auth via `X-MICROCMS-WEBHOOK-KEY`), which clears the relevant function-cache entries. On container start, `entrypoint.sh` purges the Cloudflare cache once the server is ready.

## Project Layout

```
src/
├── main.lisp          # start / stop / reload (REPL entry points)
├── app.lisp           # app composition, middleware, sub-app mounting
├── document.lisp      # top-level HTML shell
├── helper.lisp        # set-metadata, set-cache helpers
├── components/        # reusable hsx components (header, article, metadata)
├── lib/               # cms, env, time utilities
├── pages/             # file-based HTML routes
└── api/               # file-based JSON routes (revalidate, not-found)
assets/                # styles, images, static files
```

## Development

```sh
just install     # download the Tailwind binary + install qlot dependencies
just watch       # rebuild CSS on change
just build       # build the production CSS bundle
just lem         # open the Lem editor with the CSS watcher running
```

Start the server from a Lisp REPL:

```lisp
(ql:quickload :website)
(website:start)   ; serves on http://localhost:3000
(website:reload)  ; reload code and restart
(website:stop)
```

Configure via `.env` (see `.env.example`):

```
WEBSITE_ENV               # "dev" enables dev-mode caching/error pages
WEBSITE_URL               # canonical base URL
MICROCMS_SERVICE_DOMAIN
MICROCMS_API_KEY
MICROCMS_WEBHOOK_KEY      # validates the revalidate webhook
CLOUDFLARE_ZONE_ID        # optional, for cache purge on deploy
CLOUDFLARE_API_KEY
```

## Deployment

Deployed on [Coolify](https://coolify.io/), which builds the `Dockerfile` and runs the container. The `Dockerfile` builds the system with qlot, minifies the Tailwind CSS, and runs `entrypoint.sh`, which serves the app with Woo on port `3000` and purges the Cloudflare cache after the rolling update completes.
