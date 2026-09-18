(defpackage #:website/api/revalidate
  (:use #:cl
        #:jingle
        #:access)
  (:import-from #:website/lib/env
                #:microcms-webhook-key)
  (:import-from #:website/lib/cache
                #:revalidate-tag
                #:revalidate-path)
  (:export #:@post))
(in-package #:website/api/revalidate)

(defun @post (params)
  (declare (ignore params))
  (unless (string= (car (get-request-header "X-MICROCMS-WEBHOOK-KEY"))
                   (microcms-webhook-key))
    (set-response-status 401)
    (return-from @post '(:|message| "Invalid token")))
  (let* ((body (request-body-parameters *request*))
         (api (accesses body "api"))
         (id (accesses body "id"))
         (old-draft-key (accesses body "contents" "old" "draftKey"))
         (new-draft-key (accesses body "contents" "new" "draftKey")))
    (cond ((string= api "about")
           (revalidate-tag "about")
           (unless new-draft-key
             (revalidate-path "/about")))
          ((string= api "works")
           (revalidate-tag "works")
           (unless new-draft-key
             (revalidate-path "/works")))
          ((string= api "blog")
           (revalidate-tag "blog")
           (unless new-draft-key
             (revalidate-path (format nil "/blog/~a" id))
             (revalidate-path "/blog")
             (revalidate-path "/")))
          (t (set-response-status 400)
             (return-from @post '(:|message| "Unknown API"))))
    (list :|api| api
          :|id| id
          :|old-draft-key| old-draft-key
          :|new-draft-key| new-draft-key
          :|message| "ok")))
