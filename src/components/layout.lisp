(defpackage #:hp/components/layout
  (:use #:cl
        #:piccolo)
  (:local-nicknames (#:cfg #:hp/config/*))
  (:export #:layout))
(in-package #:hp/components/layout)

(define-element layout ()
  (body
    :hx-ext cfg:*hx-ext*
    :class "h-[100svh] flex flex-col"
    (header)
    (main :class "flex-1"
      children)
    ; footer
    (footer)))
