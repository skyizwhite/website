(defpackage #:website/routes/works
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:get-works)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package #:website/routes/works)

(defparameter *metadata*
  (list :title "works"))

(defun handle-get (params)
  (declare (ignore params))
  (setf (context :metadata) *metadata*)
  (hsx (p "coming soon")))
