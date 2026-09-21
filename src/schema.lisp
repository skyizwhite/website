(defpackage #:website/schema
  (:use #:cl)
  (:import-from #:koya/config
                #:defwebhooks
                #:defmodel
                #:webhook)
  (:import-from #:website/lib/env
                #:website-url
                #:koya-webhook-url))
(in-package #:website/schema)

;;; Content models of this site: the single source of truth for the koya schema
;;; of the "website" space. The space itself is made in koya's admin UI, so
;;; nothing here names it. Nothing here talks to the server either; see
;;; website/koya for plan, deploy and the other REPL commands.
;;;
;;; Every content event (publish, unpublish, delete, draft) calls /api/revalidate
;;; on this site, which acts on all but draft. KOYA_WEBHOOK_URL overrides the target, e.g.
;;; http://localhost:3000/api/revalidate when a local koya should notify a local
;;; instance of the site.

(defun revalidate-url ()
  (let ((override (koya-webhook-url)))
    (if (uiop:emptyp override)
        (format nil "~a/api/revalidate" (website-url))
        override)))

(defun page-url (path &key draft)
  "URL template for the admin UI's page links; {CONTENT_ID} and {DRAFT_KEY} are filled by koya."
  (format nil "~a~a~:[~;?draft-key={DRAFT_KEY}~]" (website-url) path draft))

;; every model, every event; the handler ignores draft saves
(defwebhooks (webhook "revalidate" (revalidate-url)))

(defmodel blog (:kind :list
                :public-url (page-url "/blog/{CONTENT_ID}")
                :preview-url (page-url "/blog/{CONTENT_ID}" :draft t))
  (title       :text :required t)
  (description :textarea)
  (content     :richtext))

(defmodel about (:kind :object
                 :public-url (page-url "/about")
                 :preview-url (page-url "/about" :draft t))
  (content :richtext))

(defmodel works (:kind :object
                 :public-url (page-url "/works")
                 :preview-url (page-url "/works" :draft t))
  (content :richtext))
