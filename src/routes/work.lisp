(defpackage #:website/routes/work
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/cms
                #:get-work)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package :website/routes/work)

(defparameter *metadata*
  (list :title "work"
        :path "/work"))

(defcomp ~page ()
  (hsx
   (p "coming soon")))

(defun handle-get (params)
  (declare (ignore params))
  (list (~page) *metadata*))
