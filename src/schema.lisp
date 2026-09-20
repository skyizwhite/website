(defpackage #:website/schema
  (:use #:cl)
  (:import-from #:koya/config
                #:defspace
                #:defmodel)
  (:import-from #:koya/core/json
                #:to-json)
  (:import-from #:koya/core/schema
                #:schema->jobject)
  ;; no symbols: only makes ASDF load the client before this file is read
  (:import-from #:koya/client)
  (:import-from #:website/lib/env
                #:website-url
                #:koya-url
                #:koya-secret
                #:koya-webhook-url)
  (:export #:plan
           #:deploy
           #:pull
           #:webhook-secret
           #:main))
(in-package #:website/schema)

;;; Content models of this site, deployed to the koya server with
;;;
;;;   just schema plan            ; diff against the server
;;;   just schema deploy          ; apply it (refuses destructive changes)
;;;   just schema deploy --force  ; apply destructive changes too
;;;   just schema pull            ; the schema currently on the server
;;;   just schema webhook-secret  ; the value to put in KOYA_WEBHOOK_KEY
;;;
;;; The server is KOYA_URL, authenticated with KOYA_SECRET (the owner secret).
;;; Publishing, updating or deleting content calls /api/revalidate on this site.
;;; KOYA_WEBHOOK_URL overrides the target, e.g. http://localhost:3000/api/revalidate
;;; when a local koya should notify a local instance of the site.

(defun revalidate-url ()
  (let ((override (koya-webhook-url)))
    (if (uiop:emptyp override)
        (format nil "~a/api/revalidate" (website-url))
        override)))

(defspace website
  :webhooks (list (revalidate-url)))

(defun page-url (path &key draft)
  "URL template for the admin UI's page links; {CONTENT_ID} and {DRAFT_KEY} are filled by koya."
  (format nil "~a~a~:[~;?draft-key={DRAFT_KEY}~]" (website-url) path draft))

(defmodel (website blog) (:kind :list
                          :public-url (page-url "/blog/{CONTENT_ID}")
                          :preview-url (page-url "/blog/{CONTENT_ID}" :draft t))
  (title       :text :required t)
  (description :textarea)
  (content     :richtext))

(defmodel (website about) (:kind :object
                           :public-url (page-url "/about")
                           :preview-url (page-url "/about" :draft t))
  (content :richtext))

(defmodel (website works) (:kind :object
                           :public-url (page-url "/works")
                           :preview-url (page-url "/works" :draft t))
  (content :richtext))

(defun connect ()
  (koya/client:configure :base-url (koya-url) :secret (koya-secret) :space "website"))

(defun plan ()
  "Print the changes DEPLOY would make. Returns them."
  (connect)
  (koya/client:plan))

(defun deploy (&key force)
  "Apply the schema to the server. Destructive changes need FORCE. Returns T on success."
  (let ((changes (plan)))
    (cond ((null changes) t)
          ((and (not force) (some (lambda (change) (getf change :destructive)) changes))
           (format t "~&Destructive changes (marked !) are only applied with --force.~%")
           nil)
          (t (koya/client:deploy :force force :confirm nil)
             t))))

(defun pull ()
  "Print the schema currently on the server as JSON. Returns the schema."
  (connect)
  (let ((schema (koya/client:pull)))
    (format t "~a~%" (to-json (schema->jobject schema) :pretty t))
    schema))

(defun webhook-secret ()
  "Print the secret koya sends as X-KOYA-WEBHOOK-KEY. Returns it."
  (connect)
  (let ((secret (koya/client:webhook-secret :space "website")))
    (format t "~a~%" secret)
    secret))

(defun main (command &optional (flags ""))
  "Entry point for `just schema COMMAND [--force]'. Exits 0 on success, 1 otherwise."
  (let ((force (member "--force" (uiop:split-string flags) :test #'string=)))
    (uiop:quit
     (handler-case
         (if (cond ((string= command "plan") (plan) t)
                   ((string= command "deploy") (deploy :force force))
                   ((string= command "pull") (pull) t)
                   ((string= command "webhook-secret") (webhook-secret) t)
                   (t (format *error-output* "~&Unknown command ~a. Use plan, deploy, pull or webhook-secret.~%" command)
                      nil))
             0
             1)
       (error (e)
         (format *error-output* "~&~a~%" e)
         1)))))
