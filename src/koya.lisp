(defpackage #:website/koya
  (:use #:cl)
  (:import-from #:website/schema
                #:define-schema)
  (:import-from #:koya-sdk/client)
  (:import-from #:website/lib/env
                #:koya-url
                #:koya-management-key)
  (:export #:plan
           #:deploy
           #:pull
           #:webhook-secret
           #:deploy-at-startup))
(in-package #:website/koya)

(defun connect ()
  (define-schema)
  (koya-sdk/client:configure :base-url (koya-url) :management-key (koya-management-key) :space "website"))

(defun plan ()
  (connect)
  (koya-sdk/client:plan))

(defun deploy (&key force)
  (connect)
  (koya-sdk/client:deploy :force force))

(defun pull ()
  (connect)
  (koya-sdk/client:pull))

(defun webhook-secret ()
  (connect)
  (koya-sdk/client:webhook-secret))

(defun deploy-at-startup ()
  (handler-case
      (let ((applied (deploy :force t)))
        (format t "~&[website] schema deployed: ~a change~:p~%" (length applied)))
    (error (e)
      (format *error-output* "~&[website] schema deploy skipped: ~a~%" e)))
  (finish-output)
  (finish-output *error-output*))
