#!/bin/sh
# Container start: push src/schema.lisp to the koya server, then serve the site.
# The deploy is forced (destructive changes included) so the schema always
# matches the code that is about to run; koya being unreachable is logged and
# does not stop the site from starting.
set -eu

qlot exec sbcl --non-interactive \
  --eval '(ql:quickload "website/koya" :silent t)' \
  --eval '(website/koya:deploy-at-startup)'

exec .qlot/bin/clackup --system website --server woo --address 0.0.0.0 --port 3000 src/app.lisp
