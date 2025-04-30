(defpackage #:hp/routes/bio
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package :hp/routes/bio)

(defparameter *metadata*
  (list :title "bio"
        :path "/bio"))

(defcomp ~page ()
  (hsx
   (section
     (p "Coming soon..."))))

(defun handle-get (params)
  (declare (ignore params))
  (list :body (~page)
        :metadata *metadata*
        :cache :dynamic))
