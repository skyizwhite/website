#!/bin/bash
set -euo pipefail

# Seconds to wait for the rolling update to switch traffic before purging the
# CDN cache. Override via the PURGE_DELAY env var.
PURGE_DELAY="${PURGE_DELAY:-60}"

purge_cache() {
  echo "Waiting for server to be ready..."
  local ready=false
  for i in $(seq 1 60); do
    if curl -sf -o /dev/null http://0.0.0.0:3000; then
      echo "Server is up."
      ready=true
      break
    fi
    sleep 1
  done

  if [[ "$ready" != true ]]; then
    echo "Server did not become ready; skipping cache purge."
    return
  fi

  if [[ -n "${CLOUDFLARE_ZONE_ID:-}" && -n "${CLOUDFLARE_API_KEY:-}" ]]; then
    echo "Waiting ${PURGE_DELAY}s for rolling update..."
    sleep "$PURGE_DELAY"
    echo "Purging Cloudflare cache..."
    curl -sf -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/purge_cache" \
      -H "Content-Type: application/json" \
      -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
      -d '{ "hosts": ["skyizwhite.dev"] }'
  else
    echo "Cloudflare credentials not provided. Skipping cache purge."
  fi
}

purge_cache &

echo "Starting server..."
exec .qlot/bin/clackup --system website --server woo --address 0.0.0.0 --port 3000 src/app.lisp
