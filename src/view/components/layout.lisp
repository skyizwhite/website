(defpackage #:hp/view/components/layout
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout))
(in-package #:hp/view/components/layout)

(pi:define-element layout ()
  (pi:h
    (body
      ; header
      (main pi:children)
      ; footer
      )))
