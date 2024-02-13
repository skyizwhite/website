(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:ui #:hp/ui/*))
  (:export #:on-get))
(in-package #:hp/routes/index)

;;; View

(pi:define-element page ()
  (pi:h
    (ui:layout
      (section :class "h-full flex justify-center items-center"
        (p :class "text-primary text-4xl"
          "Hello World!")))))

;;; Controller

(defun on-get (params)
  (declare (ignore params))
  (jg:with-html-response
    (pi:element-string (page))))
