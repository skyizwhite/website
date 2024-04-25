(defpackage #:hp/routes/about
  (:use #:cl
        #:piccolo)
  (:local-nicknames (#:view #:hp/view/*))
  (:export #:handle-get))
(in-package #:hp/routes/about)

(define-element page ()
  (div :class "h-full place-content-center"
    (h1
      :class "text-4xl text-center"
      "About")))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page)))
