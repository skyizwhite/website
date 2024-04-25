(defpackage #:hp/routes/about
  (:use #:cl
        #:piccolo)
  (:import-from #:hp/view/*
                #:render)
  (:export #:handle-get))
(in-package #:hp/routes/about)

(define-element page ()
  (div :class "h-full place-content-center"
    (h1
      :class "text-4xl text-center"
      "Coming soon...")))

(defun handle-get (params)
  (declare (ignore params))
  (render (page)))
