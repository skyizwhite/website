#!/bin/bash
set -e

if [[ -n "$CLOUDFLARE_ZONE_ID" && -n "$CLOUDFLARE_API_KEY" ]]; then
  echo "Purging Cloudflare cache..."
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/purge_cache" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
    -d '{ "hosts": ["skyizwhite.dev"] }'
else
  echo "Cloudflare credentials not provided. Skipping cache purge."
fi

echo "Starting server..."
exec .qlot/bin/clackup --system hp --server woo --address 0.0.0.0 --port 3000 src/app.lisp
