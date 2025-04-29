(defpackage #:hp/routes/blog
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package :hp/routes/blog)

(defparameter *metadata*
  (list :title "blog"))

(defcomp ~page ()
  (hsx
   (section
     (p "Coming soon..."))))

(defun handle-get (params)
  (declare (ignore params))
  (list (~page) *metadata*))
