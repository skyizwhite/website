(uiop:define-package #:hp/ui/layout
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout))
(in-package #:hp/ui/layout)

(pi:define-element layout ()
  (pi:h
    (html
      (head
        (title "skyizwhite.dev")
        (script :src "/static/htmx.min.js")
        (link :href "/static/main.css" :rel "stylesheet")
        (link :href "/static/tailwind.css" :rel "stylesheet"))
      (body :class "h-[100svh]"
        pi:children))))
