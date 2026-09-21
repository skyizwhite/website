(defpackage #:website/api/revalidate
  (:use #:cl
        #:jingle
        #:access)
  (:import-from #:website/lib/env
                #:koya-webhook-key)
  (:import-from #:website/lib/cache
                #:revalidate-tag
                #:revalidate-path)
  (:export #:@post))
(in-package #:website/api/revalidate)

(defun @post (params)
  (declare (ignore params))
  (unless (equal (car (get-request-header "X-KOYA-WEBHOOK-KEY"))
                 (koya-webhook-key))
    (set-response-status 401)
    (return-from @post '(:|message| "Invalid token")))
  ;; koya sends every event; only a change to what is published matters here
  (let* ((body (request-body-parameters *request*))
         (event (accesses body "event"))
         (api (accesses body "api"))
         (id (accesses body "id")))
    (when (equal event "draft")
      (return-from @post (list :|event| event :|message| "ignored")))
    (cond ((string= api "about")
           (revalidate-tag "about")
           (revalidate-path "/about"))
          ((string= api "works")
           (revalidate-tag "works")
           (revalidate-path "/works"))
          ((string= api "blog")
           (revalidate-tag "blog")
           (revalidate-path (format nil "/blog/~a" id))
           (revalidate-path "/blog")
           (revalidate-path "/"))
          (t (set-response-status 400)
             (return-from @post '(:|message| "Unknown API"))))
    (list :|event| event :|api| api :|id| id :|message| "ok")))
