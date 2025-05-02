(defpackage #:website/routes/blog
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package :website/routes/blog)

(defparameter *metadata*
  (list :title "blog"
        :path "/blog"))

(defcomp ~page ()
  (hsx
    (p "coming soon")))

(defun handle-get (params)
  (declare (ignore params))
  (list :body (~page)
        :metadata *metadata*
        :cache :dynamic))
