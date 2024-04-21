(defpackage #:hp/view/components/layout/main
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout))
(in-package #:hp/view/components/layout/main)

(pi:define-element layout ()
  (pi:h
    (body
      :hx-ext "head-support,alpine-morph"
      :x-data t
      :|:data-dark| "$store.darkMode.on"
      ; header
      (main pi:children)
      ; footer
      )))
