(defpackage #:hp/components/layout
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout))
(in-package #:hp/components/layout)

(pi:define-element layout ()
  (pi:h
    (body :hx-ext "head-support"
      ; header
      (main pi:children)
      ; footer
      )))
