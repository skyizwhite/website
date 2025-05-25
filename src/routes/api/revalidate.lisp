(defpackage #:website/routes/api/revalidate
  (:use #:cl
        #:jingle
        #:access)
  (:import-from #:website/lib/env
                #:microcms-webhook-key)
  (:import-from #:website/helper
                #:get-request-body-plist)
  (:import-from #:website/lib/cms
                #:clear-about-cache
                #:clear-works-cache
                #:clear-blog-cache)
  (:export #:handle-post))
(in-package #:website/routes/api/revalidate)

(defun handle-post (params)
  (declare (ignore params))
  (unless (string= (car (get-request-header "X-MICROCMS-WEBHOOK-KEY"))
                   (microcms-webhook-key))
    (set-response-status :unauthorized)
    (return-from handle-post '(:|message| "Invalid token")))
  (let* ((body (get-request-body-plist))
         (api (getf body :|api|))
         (id (getf body :|id|))
         (old-draft-key (accesses body :|contents| :|old| :|draftKey|))
         (new-draft-key (accesses body :|contents| :|new| :|draftKey|)))
    (cond ((string= api "about") (clear-about-cache new-draft-key))
          ((string= api "works") (clear-works-cache new-draft-key))
          ((string= api "blog") (clear-blog-cache id old-draft-key new-draft-key))
          (t (set-response-status :bad-request)
             (return-from handle-post '(:|message| "Unknown API"))))
    (list :|api| api
          :|id| id
          :|old-draft-key| old-draft-key
          :|new-draft-key| new-draft-key
          :|message| "ok")))
