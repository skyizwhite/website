(defpackage #:hp/routes/work
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package :hp/routes/work)

(defparameter *metadata*
  (list :title "work"
        :path "/work"))

(defcomp ~page ()
  (hsx
   (section
     (p "Coming soon..."))))

(defun handle-get (params)
  (declare (ignore params))
  (list :body (~page)
        :metadata *metadata*
        :cache :dynamic))
