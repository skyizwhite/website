(defpackage #:hp/ui/layout
  (:use #:cl)
  (:local-nicknames (#:f #:flute))
  (:export #:layout))
(in-package #:hp/ui/layout)

(f:define-element layout ()
  (f:h
    (html
     (head
      (title "skyizwhite.dev")
      (script :src "/static/htmx.min.js")
      (link :href "/static/main.css" :rel "stylesheet")
      (link :href "/static/tailwind.css" :rel "stylesheet"))
     (body :class "h-[100svh]"
           f:children))))
