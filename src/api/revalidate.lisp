(defpackage #:website/api/revalidate
  (:use #:cl
        #:website/lib/http
        #:access)
  (:import-from #:ningle
                #:*request*)
  (:import-from #:lack/request
                #:request-body-parameters)
  (:import-from #:website/lib/env
                #:koya-webhook-key)
  (:import-from #:shun
                #:revalidate-tag
                #:revalidate-path)
  (:export #:@post
           #:payload-targets
           #:revalidate-targets))
(in-package #:website/api/revalidate)

(defparameter *acted-on* '("publish" "unpublish" "delete"))

(defun revalidate-targets (event model id)
  (cond ((not (member event *acted-on* :test #'equal))
         (values '() '() :ignored))
        ((equal model "about")
         (values '("about") '("/about") :ok))
        ((equal model "works")
         (values '("works") '("/works") :ok))
        ((equal model "blog")
         (values '("blog") (list (format nil "/blog/~a" id) "/blog" "/") :ok))
        (t
         (values '() '() :unknown))))

(defun payload-targets (body)
  (let ((event (accesses body "event"))
        (model (accesses body "model"))
        (id (accesses body "id")))
    (multiple-value-bind (tags paths status) (revalidate-targets event model id)
      (values tags paths status event model id))))

(defun @post (params)
  (declare (ignore params))
  (unless (equal (get-request-header "X-KOYA-WEBHOOK-KEY")
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
       (list :|message| "Unknown model" :|model| model))
      (:ok
       (mapc #'revalidate-tag tags)
       (mapc #'revalidate-path paths)
       (list :|event| event :|model| model :|id| id :|message| "ok")))))
