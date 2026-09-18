(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:microcms-error
                #:microcms-error-status)
  (:import-from #:website/lib/cache
                #:deffetcher)
  (:import-from #:website/lib/env
                #:microcms-service-domain
                #:microcms-api-key)
  (:export #:with-cms-fallback
           #:fetch-about
           #:fetch-works
           #:fetch-blog-list
           #:fetch-recent-blog-list
           #:fetch-blog-detail
           #:fetch-blog-likes
           #:update-blog-likes
           #:increment-blog-likes))
(in-package #:website/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(defmacro with-cms-fallback (clauses &body body)
  "Evaluate BODY. If microCMS signals a `microcms-error', dispatch on its
HTTP status using CLAUSES, which share CASE's shape keyed on the status
code (use T for the default):

  (with-cms-fallback ((404 (error-page 404))
                      (t   (error-page 500)))
    ...)"
  (let ((e (gensym "ERROR")))
    `(handler-case (progn ,@body)
       (microcms-error (,e)
         (case (microcms-error-status ,e)
           ,@clauses)))))

(deffetcher fetch-about (&key draft-key) ("about")
  (microcms:get-object "about" :query (list :draft-key draft-key)))

(deffetcher fetch-works (&key draft-key) ("works")
  (microcms:get-object "works" :query (list :draft-key draft-key)))

(deffetcher fetch-blog-list (&key page) ("blog")
  ;TODO: pagenation
  (declare (ignore page))
  (getf (microcms:get-list "blog" :query '(:fields "id,title,publishedAt"
                                           :limit 100))
        :contents))

(deffetcher fetch-recent-blog-list () ("blog")
  (getf (microcms:get-list "blog" :query '(:fields "id,title,publishedAt"
                                           :limit 3))
        :contents))

(deffetcher fetch-blog-detail (id &key draft-key) ("blog")
  (microcms:get-item "blog" id :query (list :draft-key draft-key)))

(defun fetch-blog-likes (id)
  (getf (microcms:get-item "blog" id :query (list :fields "likes"))
        :likes))

(defun update-blog-likes (id likes)
  (microcms:update-item "blog" id (list :likes likes)))

(defun increment-blog-likes (id)
  (let ((new-likes (+ (fetch-blog-likes id) 1)))
    (update-blog-likes id new-likes)
    new-likes))

; For debugging
(defun reset-blog-likes (id &optional (likes 0))
  (microcms:update-item "blog" id (list :likes likes)))
