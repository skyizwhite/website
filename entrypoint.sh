#!/bin/bash
set -e

echo "Starting server..."
.qlot/bin/clackup --system website --server woo --address 0.0.0.0 --port 3000 src/app.lisp &

SERVER_PID=$!

echo "Waiting for server to be ready..."
for i in {1..20}; do
  if curl -s -o /dev/null -w "%{http_code}" -I http://0.0.0.0:3000 | grep -q "200"; then
    echo "Server is up."
    break
  fi
  echo "Server not ready yet... retrying ($i)"
  sleep 5
done

if [[ -n "$CLOUDFLARE_ZONE_ID" && -n "$CLOUDFLARE_API_KEY" ]]; then
  echo "Waiting for rolling update..."
  sleep 60
  echo "Purging Cloudflare cache..."
  curl -s -X POST "https://api.cloudflare.com/client/v4/zones/${CLOUDFLARE_ZONE_ID}/purge_cache" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${CLOUDFLARE_API_KEY}" \
    -d '{ "hosts": ["skyizwhite.dev"] }'
else
  echo "Cloudflare credentials not provided. Skipping cache purge."
fi

wait $SERVER_PID
