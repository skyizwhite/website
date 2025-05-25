(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:define-list-client
                #:define-object-client)
  (:import-from #:function-cache
                #:defcached
                #:clear-cache
                #:clear-cache-partial-arguments)
  (:import-from #:website/lib/env
                #:microcms-service-domain
                #:microcms-api-key)
  (:export #:fetch-about
           #:fetch-works
           #:fetch-blog-list
           #:fetch-blog-detail
           #:clear-about-cache
           #:clear-works-cache
           #:clear-blog-list-cache
           #:clear-blog-detail-cache))
(in-package #:website/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(define-object-client about)
(define-object-client works)
(define-list-client blog)

(defcached fetch-about (&key draft-key)
  (get-about :query (list :draft-key draft-key)))

(defcached fetch-works (&key draft-key)
  (get-works :query (list :draft-key draft-key)))

(defcached fetch-blog-list (&key page)
  ;TODO: pagenation
  (declare (ignore page))
  (getf (get-blog-list :query '(:fields "id,title,publishedAt"
                                :limit 100))
        :contents))

(defcached fetch-blog-detail (id &key draft-key)
  (get-blog-detail id :query (list :draft-key draft-key)))

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
      (clear-detail-cache id old-draft-key))
    (clear-detail-cache id new-draft-key)))

