#!/bin/bash
set -e

.qlot/bin/clackup --system website --server woo --address 0.0.0.0 --port 3000 src/app.lisp
