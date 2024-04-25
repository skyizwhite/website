(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view/*))
  (:export #:handle-get))
(in-package #:hp/routes/index)

(pi:define-element page ()
  (pi:h
    (div :data-css "pages/index.css"
      (h1 "Hello, World!"))))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page)))
