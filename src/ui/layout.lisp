(defpackage #:hp/ui/layout
  (:use #:cl)
  (:local-nicknames (#:mk #:markup))
  (:export #:layout))
(in-package #:hp/ui/layout)

(markup:enable-reader)

(mk:deftag layout (children)
  <html>
    <head>
      <title>skyizwhite.dev</title>
      <script src="/static/htmx.min.js" ></script>
    </head>
    <body>,@(progn children)</body>
  </html>)
