(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:website/helper)
  (:export #:@get))
(in-package #:website/pages/index)

(defun @get (params)
  (declare (ignore params))
  (hsx
   (div
    (h1 "Hello, World!"))))
