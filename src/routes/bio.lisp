(defpackage #:website/routes/bio
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/cms
                #:get-bio)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package :website/routes/bio)

(defparameter *metadata*
  (list :title "bio"
        :path "/bio"))

(defcomp ~page ()
  (hsx
    (p "coming soon")))

(defun handle-get (params)
  (declare (ignore params))
  (list :body (~page)
        :metadata *metadata*
        :cache :dynamic))
