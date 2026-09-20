(defpackage #:website/schema
  (:use #:cl)
  (:import-from #:koya/config
                #:defspace
                #:defmodel
                #:webhook)
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
           #:webhook-secret))
(in-package #:website/schema)

;;; Content models of this site, deployed to the koya server from the REPL:
;;;
;;;   (ql:quickload :website/schema)
;;;   (website/schema:plan)             ; diff against the server
;;;   (website/schema:deploy)           ; apply it, asking before destructive changes
;;;   (website/schema:deploy :force t)  ; apply destructive changes without asking
;;;   (website/schema:pull)             ; the schema currently on the server
;;;   (website/schema:webhook-secret)   ; the value to put in KOYA_WEBHOOK_KEY
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
  ;; every model: publish, unpublish and delete revalidate the site
  :webhooks (list (webhook "revalidate" (revalidate-url))))

(defun page-url (path &key draft)
  "URL template for the admin UI's page links; {CONTENT_ID} and {DRAFT_KEY} are filled by koya."
  (format nil "~a~a~:[~;?draft-key={DRAFT_KEY}~]" (website-url) path draft))

(defmodel (website blog) (:kind :list
                          :public-url (page-url "/blog/{CONTENT_ID}")
                          :preview-url (page-url "/blog/{CONTENT_ID}" :draft t)
                          ;; blog only: a draft save also revalidates, so the draft
                          ;; preview shows the latest text (the space hook covers publish)
                          :webhooks (list (webhook "blog-draft-preview" (revalidate-url) :events '(:draft))))
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
  (koya/client:webhook-secret :space "website"))
