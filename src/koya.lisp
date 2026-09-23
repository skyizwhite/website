(defpackage #:website/koya
  (:use #:cl)
  (:import-from #:website/schema
                #:define-schema)
  (:import-from #:koya/client)
  (:import-from #:website/lib/env
                #:koya-url
                #:koya-management-key)
  (:export #:plan
           #:deploy
           #:pull
           #:webhook-secret
           #:deploy-at-startup))
(in-package #:website/koya)

;;; Operating the koya server for this site, from the REPL:
;;;
;;;   (ql:quickload :website/koya)
;;;   (website/koya:plan)             ; diff src/schema.lisp against the server
;;;   (website/koya:deploy)           ; apply it, asking before destructive changes
;;;   (website/koya:deploy :force t)  ; apply destructive changes without asking
;;;   (website/koya:pull)             ; the schema currently on the server
;;;   (website/koya:webhook-secret)   ; the value to put in KOYA_WEBHOOK_KEY
;;;
;;; The server is KOYA_URL, authenticated with KOYA_MANAGEMENT_KEY: a management
;;; key made on the Keys page of the "website" space in koya's admin UI. The key
;;; reaches that space and nothing else; the owner secret only logs into the UI.
;;;
;;; The space has to exist before any of this works -- koya makes spaces in its
;;; admin UI, never from a deploy -- and a deploy to a missing one is a 404.

(defun connect ()
  (define-schema)
  (koya/client:configure :base-url (koya-url) :management-key (koya-management-key) :space "website"))

(defun plan ()
  "Print the changes DEPLOY would make. Returns them."
  (connect)
  (koya/client:plan))

(defun deploy (&key force)
  "Apply the schema to the server. Destructive changes are confirmed interactively,
or applied without asking with FORCE. Returns the applied changes."
  (connect)
  (koya/client:deploy :force force))

(defun pull ()
  "The schema currently on the server, as a koya schema object."
  (connect)
  (koya/client:pull))

(defun webhook-secret ()
  "The secret koya sends as X-KOYA-WEBHOOK-KEY."
  (connect)
  (koya/client:webhook-secret))

(defun deploy-at-startup ()
  "Force-deploy the schema and report; used by website:main before the site
starts. Never signals: a koya that is down, a bad KOYA_MANAGEMENT_KEY or a space that
was never made in koya's admin UI is printed, and the site starts anyway (its
content calls will fail on their own)."
  (handler-case
      (let ((applied (deploy :force t)))
        (format t "~&[website] schema deployed: ~a change~:p~%" (length applied)))
    (error (e)
      (format *error-output* "~&[website] schema deploy skipped: ~a~%" e)))
  (finish-output)
  (finish-output *error-output*))
