(defpackage #:website/routes/work
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:get-work)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package #:website/routes/work)

(defparameter *metadata*
  (list :title "work"))

(defun handle-get (params)
  (declare (ignore params))
  (setf (context :metadata) *metadata*)
  (hsx (p "coming soon")))
