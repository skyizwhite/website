(defpackage #:website/lib/asset-cache
  (:use #:cl)
  (:import-from #:website/lib/etag
                #:*revalidate-cache-control*)
  (:export #:*immutable-cache-control*
           #:*asset-cache-middleware*))
(in-package #:website/lib/asset-cache)

(defparameter *immutable-cache-control* "public, max-age=31536000, immutable")

(defun asset-path-p (path)
  (uiop:string-prefix-p "/assets/" path))

(defun versioned-path-p (path query)
  (or (and query (uiop:string-prefix-p "v=" query))
      (uiop:string-prefix-p "/assets/fonts/" path)
      (uiop:string-prefix-p "/assets/style/fonts-" path)))

(defun asset-cache-control (path query)
  (if (versioned-path-p path query)
      *immutable-cache-control*
      *revalidate-cache-control*))

(defun with-cache-control (headers value)
  (list* :cache-control value
         (loop
           :for (key val) :on headers :by #'cddr
           :unless (eq key :cache-control) :append (list key val))))

(defparameter *asset-cache-middleware*
  (lambda (app)
    (lambda (env)
      (let* ((path (getf env :path-info))
             (query (getf env :query-string))
             (res (funcall app env)))
        (if (and (asset-path-p path)
                 (listp res)
                 (member (first res) '(200 304)))
            (destructuring-bind (status headers body) res
              (list status
                    (with-cache-control headers (asset-cache-control path query))
                    body))
            res)))))
