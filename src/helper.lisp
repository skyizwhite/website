(defpackage #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:export #:set-metadata))
(in-package #:website/helper)

(defun set-metadata (metadata)
  (setf (context :metadata) metadata))
