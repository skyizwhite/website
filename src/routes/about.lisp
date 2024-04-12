(defpackage #:hp/routes/about
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:export #:on-get))
(in-package #:hp/routes/about)

(pi:define-element page ()
  (pi:h
    (section
      (h1 "About"))))

(defun on-get (params)
  (declare (ignore params))
  (view:render (page)
               :title "about"
               :description "pakuの自己紹介"))
