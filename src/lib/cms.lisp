(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:microcms-error
                #:microcms-error-status)
  (:import-from #:function-cache
                #:defcached
                #:clear-cache
                #:clear-cache-partial-arguments)
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
           #:increment-blog-likes
           #:clear-about-cache
           #:clear-works-cache
           #:clear-blog-cache))
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

(defcached fetch-about (&key draft-key)
  (microcms:get-object "about" :query (list :draft-key draft-key)))

(defcached fetch-works (&key draft-key)
  (microcms:get-object "works" :query (list :draft-key draft-key)))

(defcached fetch-blog-list (&key page)
  ;TODO: pagenation
  (declare (ignore page))
  (getf (microcms:get-list "blog" :query '(:fields "id,title,publishedAt"
                                           :limit 100))
        :contents))

(defcached fetch-recent-blog-list ()
  (getf (microcms:get-list "blog" :query '(:fields "id,title,publishedAt"
                                           :limit 3))
        :contents))

(defcached fetch-blog-detail (id &key draft-key)
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

(defun clear-about-cache (new-draft-key)
  (if new-draft-key
      (clear-cache-partial-arguments *fetch-about-cache* `(:draft-key ,new-draft-key))
      (clear-cache *fetch-about-cache*)))

(defun clear-works-cache (new-draft-key)
  (if new-draft-key
      (clear-cache-partial-arguments *fetch-works-cache* `(:draft-key ,new-draft-key))
      (clear-cache *fetch-works-cache*)))

(defun clear-blog-cache (id old-draft-key new-draft-key)
  (labels ((clear-detail-cache (id draft-key)
             (clear-cache-partial-arguments *fetch-blog-detail-cache*
                                            `(,id :draft-key ,draft-key))))
    (unless new-draft-key
      (clear-cache *fetch-blog-list-cache*)
      (clear-cache *fetch-recent-blog-list-cache*)
      (clear-detail-cache id old-draft-key))
    (clear-detail-cache id new-draft-key)))

