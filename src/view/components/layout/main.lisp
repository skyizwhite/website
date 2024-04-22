(defpackage #:hp/view/components/layout/main
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:export #:layout))
(in-package #:hp/view/components/layout/main)

(pi:define-element layout ()
  (pi:h
    (body
      :hx-ext cfg:*hx-ext*
      :x-data t
      :|:data-dark| "$store.darkMode.on"
      ; header
      (main pi:children)
      ; footer
      )))
