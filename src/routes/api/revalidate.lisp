(defpackage #:website/routes/api/revalidate
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:microcms-webhook-key)
  (:import-from #:website/helper
                #:get-request-body-plist)
  (:import-from #:website/lib/cms
                #:get-about
                #:get-works)
  (:import-from #:website/lib/cache
                #:clear-cache)
  (:export #:handle-post))
(in-package #:website/routes/api/revalidate)

(defun handle-post (params)
  (declare (ignore params))
  (unless (string= (car (get-request-header "X-MICROCMS-WEBHOOK-KEY"))
                   (microcms-webhook-key))
    (set-response-status :unauthorized)
    (return-from handle-post '(:|message| "Invalid token")))
  (let* ((body (get-request-body-plist))
         (api (getf body :|api|)))
    (cond ((string= api "about") (clear-cache 'get-about))
          ((string= api "works") (clear-cache 'get-works)))
    '(:|message| "ok")))
