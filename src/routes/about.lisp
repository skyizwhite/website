(defpackage #:website/routes/about
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:get-about)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package :website/routes/about)

(defparameter *metadata*
  (list :title "about"))

(defcomp ~page ()
  (hsx
   (p "coming soon")))

(defun handle-get (params)
  (declare (ignore params))
  (setf (context :metadata) *metadata*)
  (~page))
