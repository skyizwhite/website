(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/lib/etag
                #:*swr-cache-control*)
  (:import-from #:website/components/error-page
                #:~error-page
                #:error-metadata)
  (:export #:set-metadata
           #:set-cache
           #:asset-path
           #:with-nm-request
           #:error-action
           #:error-page))
(in-package #:website/helper)

(defun asset-path (path &key (bust t))
  (format nil "/assets/~a~@[?v=~a~]" path (and bust #.(get-universal-time))))

(defun set-metadata (metadata)
  (setf (context :metadata) metadata))

(defun set-cache (strategy)
  (cond ((dev-mode-p)
         (set-response-header :cache-control "private, no-store, must-revalidate"))
        ((eq strategy :ssr)
         (set-response-header :cache-control "public, max-age=0, must-revalidate"))
        ((eq strategy :swr)
         (set-response-header :cache-control *swr-cache-control*))))

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
