(defpackage #:website/api/revalidate
  (:use #:cl
        #:jingle
        #:access)
  (:import-from #:website/lib/env
                #:microcms-webhook-key)
  (:import-from #:website/lib/cms
                #:clear-about-cache
                #:clear-works-cache
                #:clear-blog-cache)
  (:export #:@post))
(in-package #:website/api/revalidate)

(defun @post (params)
  (declare (ignore params))
  (unless (string= (car (get-request-header "X-MICROCMS-WEBHOOK-KEY"))
                   (microcms-webhook-key))
    (set-response-status :unauthorized)
    (return-from @post '(:|message| "Invalid token")))
  (let* ((body (request-body-parameters *request*))
         (api (accesses body "api"))
         (id (accesses body "id"))
         (old-draft-key (accesses body "contents" "old" "draftKey"))
         (new-draft-key (accesses body "contents" "new" "draftKey")))
    (cond ((string= api "about") (clear-about-cache new-draft-key))
          ((string= api "works") (clear-works-cache new-draft-key))
          ((string= api "blog") (clear-blog-cache id old-draft-key new-draft-key))
          (t (set-response-status :bad-request)
             (return-from @post '(:|message| "Unknown API"))))
    (list :|api| api
          :|id| id
          :|old-draft-key| old-draft-key
          :|new-draft-key| new-draft-key
          :|message| "ok")))
