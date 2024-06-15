(uiop:define-package #:hp/routes/index
  (:use #:cl
        #:hsx
        #:hp/response)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(defcomp page ()
  (hsx
   (h1 "こんにちは")))

(defun handle-get (params)
  (declare (ignore params))
  (response (page)))
