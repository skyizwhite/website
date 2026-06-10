(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/components/error-page
                #:~error-page
                #:error-metadata)
  (:export #:set-metadata
           #:set-cache
           #:with-nm-request
           #:error-action
           #:error-page))
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

(defmacro with-nm-request (&body body)
  `(cond ((get-request-header "nm-request")
          ,@body)
         (t
          (set-response-status 400)
          nil)))

(defun error-action (status &optional body)
  (set-response-status status)
  body)

(defun error-page (&optional (status 500))
  (set-cache :ssr)
  (set-response-status status)
  (set-metadata (error-metadata status))
  (~error-page :status status))
