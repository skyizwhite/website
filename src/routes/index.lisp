(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:export #:on-get))
(in-package #:hp/routes/index)

;;; View

(pi:define-element page ()
  (pi:h
    (section
      (h1 "Hello, World!")
      (a :href "/about" :hx-boost "true"
        "About"))))

;;; Controller

(defun on-get (params)
  (declare (ignore params))
  (view:render (page)))
