(defpackage #:hp/routes/about
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:export #:on-get))
(in-package #:hp/routes/about)

;;; View

(pi:define-element page ()
  (pi:h
    (section
      (h1 "About"))))

;;; Controller

(defun on-get (params)
  (declare (ignore params))
  (view:render-page (page)
                     :title "about"
                     :description "pakuの自己紹介"))
