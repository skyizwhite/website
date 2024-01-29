(defpackage #:hp/components/layout
  (:use #:cl)
  (:import-from #:markup)
  (:export #:layout))
(in-package #:hp/components/layout)

(markup:enable-reader)

(markup:deftag layout (children)
  <html>
    <head>
      <title>skyizwhite.dev</title>
      <script src="https://unpkg.com/htmx.org@1.3.1"></script>
    </head>
    <body>,@(progn children)</body>
  </html>)
