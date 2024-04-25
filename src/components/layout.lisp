(defpackage #:hp/components/layout
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cfg #:hp/config/*))
  (:export #:layout))
(in-package #:hp/components/layout)

(pi:define-element layout ()
  (pi:h
    (body
      :hx-ext cfg:*hx-ext*
      :class "h-[100svh] flex flex-col"
      (header)
      (main :class "flex-1"
        pi:children)
      ; footer
      (footer))))
