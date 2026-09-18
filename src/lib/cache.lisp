(defpackage #:website/lib/cache
  (:use #:cl)
  (:import-from #:function-cache
                #:defcached
                #:clear-cache)
  (:export #:deffetcher
           #:revalidate-tag
           #:revalidate-path
           #:page-version))
(in-package #:website/lib/cache)

(defvar *tagged-caches* (make-hash-table :test #'equal))

(defmacro deffetcher (name lambda-list tags &body body)
  (let ((cache (intern (format nil "*~a-CACHE*" (symbol-name name))
                       (symbol-package name))))
    `(progn
       (defcached ,name ,lambda-list ,@body)
       (dolist (tag ',tags)
         (pushnew ,cache (gethash tag *tagged-caches*)))
       ',name)))

(defun revalidate-tag (tag)
  (multiple-value-bind (caches found) (gethash tag *tagged-caches*)
    (unless found
      (error "No fetcher is tagged ~s" tag))
    (dolist (cache caches)
      (clear-cache cache))
    tag))

(defvar *page-versions* (make-hash-table :test #'equal))

(defun page-version (path)
  (gethash path *page-versions* 0))

(defun revalidate-path (path)
  (incf (gethash path *page-versions* 0))
  path)
