(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:export #:handle-get))
(in-package #:hp/routes/index)

(pi:define-element page ()
  (pi:h
    (section :data-cmp "pages/index"
      (h1 "Hello, World!")
      (a :href "/about" :hx-boost "true"
        "About"))))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page)))
