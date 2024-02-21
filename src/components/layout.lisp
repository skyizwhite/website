(uiop:define-package #:hp/components/layout
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout))
(in-package #:hp/components/layout)

(pi:define-element layout ()
  (pi:h
    (html
      (head
        (title "skyizwhite.dev")
        (script :src "/static/vendor/htmx.min.js")
        (script :defer t :src "/static/vendor/alpine.min.js")
        (link :href "/static/style/main.css" :rel "stylesheet")
        (link :href "/static/style/tailwind.css" :rel "stylesheet"))
      (body :class "h-[100svh] w-screen"
        (main :class "h-full"
          pi:children)))))
