(defpackage #:website/schema
  (:use #:cl)
  (:import-from #:koya-sdk/config
                #:clear-schema
                #:defwebhooks
                #:defmodel
                #:webhook)
  (:import-from #:website/lib/env
                #:website-url
                #:koya-webhook-url)
  (:export #:define-schema))
(in-package #:website/schema)

(defun revalidate-url ()
  (let ((override (koya-webhook-url)))
    (if (uiop:emptyp override)
        (format nil "~a/api/revalidate" (website-url))
        override)))

(defun page-url (path &key draft)
  (format nil "~a~a~:[~;?draft-key={DRAFT_KEY}~]" (website-url) path draft))

(defun define-schema ()
  (clear-schema)
  (defwebhooks (webhook "revalidate" (revalidate-url)))

  (defmodel blog (:kind :list
                  :label title
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
    (content :richtext)))
