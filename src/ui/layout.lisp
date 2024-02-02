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
      <link href="/static/main.css" rel="stylesheet">
      <link href="/static/tailwind.css" rel="stylesheet">
    </head>
    <body class="h-[100svh]" >,@(progn children)</body>
  </html>)
