(defpackage #:hp/routes/about
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:export #:on-get))
(in-package #:hp/routes/about)

(defparameter *metadata*
  '(:title "about"
    :description "pakuの自己紹介"))

(pi:define-element page ()
  (pi:h
    (section
      (h1 "About"))))

(defun on-get (params)
  (declare (ignore params))
  (view:render (page) :metadata *metadata*))
