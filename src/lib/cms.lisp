(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:koya-sdk/client
                #:koya-error
                #:koya-error-status)
  (:import-from #:shun
                #:deffetcher)
  (:export #:with-cms-fallback
           #:fetch-about
           #:fetch-works
           #:fetch-blog-list
           #:fetch-recent-blog-list
           #:fetch-blog-detail))
(in-package #:website/lib/cms)

(setf koya-sdk/client:*space* "website")

(defmacro with-cms-fallback (clauses &body body)
  "Evaluate BODY. If koya signals a `koya-error', dispatch on its HTTP status
using CLAUSES, which share CASE's shape keyed on the status code (use T for
the default):

  (with-cms-fallback ((404 (error-page 404))
                      (t   (error-page 500)))
    ...)"
  (let ((e (gensym "ERROR")))
    `(handler-case (progn ,@body)
       (koya-error (,e)
         (case (koya-error-status ,e)
           ,@clauses)))))

(deffetcher fetch-about (&key draft-key) ("about")
  (koya-sdk/client:get-object 'about :query (list :draft-key draft-key)))

(deffetcher fetch-works (&key draft-key) ("works")
  (koya-sdk/client:get-object 'works :query (list :draft-key draft-key)))

(deffetcher fetch-blog-list (&key page) ("blog")
  (declare (ignore page))
  (getf (koya-sdk/client:get-list 'blog :query '(:fields "id,title,publishedAt"
                                             :orders "-createdAt"
                                             :limit 100))
        :contents))

(deffetcher fetch-recent-blog-list () ("blog")
  (getf (koya-sdk/client:get-list 'blog :query '(:fields "id,title,publishedAt"
                                             :orders "-createdAt"
                                             :limit 3))
        :contents))

(deffetcher fetch-blog-detail (id &key draft-key) ("blog")
  (koya-sdk/client:get-item 'blog id :query (list :draft-key draft-key)))
