(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/components/error-page
                #:~error-page)
  (:export #:set-metadata
           #:set-cache
           #:with-htmx
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

(defmacro with-htmx (&body body)
  `(cond ((get-request-header "HX-Request")
          ,@body)
         (t
          (set-response-status 400)
          nil)))

(defun error-action (status &optional body)
  (set-response-status status)
  body)

(defparameter *error-info*
  '((404 :title "Page not found"
     :description "The page you are looking for may have been deleted or the URL might be incorrect."
     :message "お探しのページは削除されたか、URL が間違っている可能性があります。")
    (500 :title "Something went wrong"
     :description "Something went wrong while loading this page. Please try again later."
     :message "問題が発生しました。しばらくしてから再度お試しください。"))
  "Per-status copy for the error page, keyed by HTTP status code.")

(defun error-page (&optional (status 500))
  (let ((info (cdr (assoc status *error-info*))))
    (set-cache :ssr)
    (set-response-status status)
    (set-metadata (list :title (getf info :title)
                        :description (getf info :description)
                        :error t))
    (~error-page
      :status status
      :title (getf info :title)
      :message (getf info :message))))
