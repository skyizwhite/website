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
  ;; koya sends every event; only a change to what is published matters here.
  ;; The payload names the space and the model as the schema does (koya 0.4.0;
  ;; it used to say "service" and "api").
  (let* ((body (request-body-parameters *request*))
         (event (accesses body "event"))
         (model (accesses body "model"))
         (id (accesses body "id")))
    (when (equal event "draft")
      (return-from @post (list :|event| event :|message| "ignored")))
    (cond ((string= model "about")
           (revalidate-tag "about")
           (revalidate-path "/about"))
          ((string= model "works")
           (revalidate-tag "works")
           (revalidate-path "/works"))
          ((string= model "blog")
           (revalidate-tag "blog")
           (revalidate-path (format nil "/blog/~a" id))
           (revalidate-path "/blog")
           (revalidate-path "/"))
          ;; koya shows this body in its delivery log, so say what was unknown
          (t (set-response-status 400)
             (return-from @post (list :|message| "Unknown model" :|model| model))))
    (list :|event| event :|model| model :|id| id :|message| "ok")))
