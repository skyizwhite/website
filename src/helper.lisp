(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:export #:set-metadata
           #:set-cache))
(in-package #:website/helper)

(defun set-metadata (metadata)
  (setf (context :metadata) metadata))

(defun set-cache (strategy)
  (cond ((dev-mode-p)
         (set-response-header :cache-control "private, no-store, must-revalidate"))
        ((eq strategy :ssr)
         (set-response-header :cache-control "public, max-age=0, must-revalidate"))
        ((eq strategy :isr)
         (set-response-header :cache-control "public, max-age=0, s-maxage=60, stale-while-revalidate=60"))
        ((eq strategy :sg)
         (set-response-header :cache-control "public, max-age=0, s-maxage=31536000, must-revalidate"))))
