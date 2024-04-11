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
        (script :src "/js/htmx.min.js")
        (script :src "/js/htmx-ext/head-support.js")
        (script :src "/js/alpine.min.js" :defer t)
        (link :rel "stylesheet" :href "/style/main.css" type="text/css"))
      (body :hx-ext "head-support"
        (main
          pi:children)))))
