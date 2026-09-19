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

(defspace website
  :webhooks (list (format nil "~a/api/revalidate" (website-url))))

(defmodel (website blog) (:kind :list)
  (title       :text :required t)
  (description :textarea)
  (content     :richtext))

(defmodel (website about) (:kind :object)
  (content :richtext))

(defmodel (website works) (:kind :object)
  (content :richtext))
