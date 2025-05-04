(defpackage #:website/routes/blog
  (:use #:cl
        #:hsx
        #:jingle)
  (:export #:handle-get))
(in-package #:website/routes/blog)

(defparameter *metadata*
  (list :title "blog"))

(defcomp ~page ()
  (hsx
   (p "coming soon")))

(defun handle-get (params)
  (declare (ignore params))
  (setf (context :metadata) *metadata*)
  (~page))
