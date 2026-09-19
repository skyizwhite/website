(defpackage #:website/schema
  (:use #:cl)
  (:import-from #:koya/config
                #:defspace
                #:defmodel)
  (:import-from #:website/lib/env
                #:website-url))
(in-package #:website/schema)

;;; Content models of this site, deployed to the koya server with
;;;
;;;   (ql:quickload :website/schema)
;;;   (koya:configure :base-url "https://cms.example.com" :secret "...")
;;;   (koya:plan)
;;;   (koya:deploy)
;;;
;;; Publishing, updating or deleting content calls /api/revalidate on this site.
;;; KOYA_WEBHOOK_URL overrides the target, e.g. http://localhost:3000/api/revalidate
;;; when a local koya should notify a local instance of the site.

(defun revalidate-url ()
  (let ((override (uiop:getenv "KOYA_WEBHOOK_URL")))
    (if (and override (plusp (length override)))
        override
        (format nil "~a/api/revalidate" (website-url)))))

(defspace website
  :webhooks (list (revalidate-url)))

(defmodel (website blog) (:kind :list)
  (title       :text :required t)
  (description :textarea)
  (content     :richtext))

(defmodel (website about) (:kind :object)
  (content :richtext))

(defmodel (website works) (:kind :object)
  (content :richtext))
