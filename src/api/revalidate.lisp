(defpackage #:website/api/revalidate
  (:use #:cl
        #:jingle
        #:access)
  (:import-from #:website/lib/env
                #:koya-webhook-key)
  (:import-from #:website/lib/cache
                #:revalidate-tag
                #:revalidate-path)
  (:export #:@post
           #:payload-targets
           #:revalidate-targets))
(in-package #:website/api/revalidate)

;;; koya posts every content event here and the payload names which. It names
;;; the space and the model the way the schema does -- "space" and "model".

(defun revalidate-targets (event model id)
  "What EVENT on MODEL invalidates, as (values TAGS PATHS STATUS). STATUS is
:IGNORED for a draft save, which changes nothing that is published, and
:UNKNOWN for a model this site does not serve."
  (cond ((equal event "draft")
         (values '() '() :ignored))
        ((equal model "about")
         (values '("about") '("/about") :ok))
        ((equal model "works")
         (values '("works") '("/works") :ok))
        ((equal model "blog")
         ;; the post itself, the index it appears in, and the front page
         (values '("blog") (list (format nil "/blog/~a" id) "/blog" "/") :ok))
        (t
         (values '() '() :unknown))))

(defun payload-targets (body)
  "REVALIDATE-TARGETS for a decoded koya payload: the keys it is read by are
here, and nowhere else. Returns (values TAGS PATHS STATUS EVENT MODEL ID)."
  (let ((event (accesses body "event"))
        (model (accesses body "model"))
        (id (accesses body "id")))
    (multiple-value-bind (tags paths status) (revalidate-targets event model id)
      (values tags paths status event model id))))

(defun @post (params)
  (declare (ignore params))
  (unless (equal (car (get-request-header "X-KOYA-WEBHOOK-KEY"))
                 (koya-webhook-key))
    (set-response-status 401)
    (return-from @post '(:|message| "Invalid token")))
  (multiple-value-bind (tags paths status event model id)
      (payload-targets (request-body-parameters *request*))
    (ecase status
      (:ignored
       (list :|event| event :|message| "ignored"))
      (:unknown
       (set-response-status 400)
       ;; koya keeps what this hook answered and shows it in its delivery
       ;; log, so the body is worth naming what was unknown
       (list :|message| "Unknown model" :|model| model))
      (:ok
       (mapc #'revalidate-tag tags)
       (mapc #'revalidate-path paths)
       (list :|event| event :|model| model :|id| id :|message| "ok")))))
