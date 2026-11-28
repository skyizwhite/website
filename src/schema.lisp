(defpackage #:website/schema
  (:use #:cl)
  (:import-from #:koya-sdk/config
                #:clear-schema
                #:defwebhooks
                #:defmodel
                #:webhook)
  (:import-from #:website/lib/env
                #:website-url
                #:dev-mode-p)
  (:export #:define-schema))
(in-package #:website/schema)

(defun revalidate-url ()
  (format nil "~a/api/revalidate" (website-url)))

(defun page-url (path &key draft)
  (format nil "~a~a~:[~;?draft-key={DRAFT_KEY}~]" (website-url) path draft))

(defun define-schema ()
  (clear-schema)
  (unless (dev-mode-p)
    (defwebhooks (webhook "revalidate" (revalidate-url))))

  (defmodel blog (:kind :list
                  :label title
                  :public-url (page-url "/blog/{CONTENT_ID}")
                  :preview-url (page-url "/blog/{CONTENT_ID}" :draft t)
                  :history t)
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
