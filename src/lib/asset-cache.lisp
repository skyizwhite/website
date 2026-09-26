(defpackage #:website/lib/asset-cache
  (:use #:cl)
  (:import-from #:lack-mw
                #:with-args
                #:*cache-control*)
  (:import-from #:website/lib/etag
                #:*revalidate-cache-control*)
  (:export #:*immutable-cache-control*
           #:*asset-cache-middleware*))
(in-package #:website/lib/asset-cache)

(defparameter *immutable-cache-control* "public, max-age=31536000, immutable")

(defun versioned-path-p (path query)
  (or (and query (uiop:string-prefix-p "v=" query))
      (uiop:string-prefix-p "/assets/fonts/" path)
      (uiop:string-prefix-p "/assets/style/fonts-" path)))

(defun versioned-asset-p (env res)
  (declare (ignore res))
  (let ((path (getf env :path-info)))
    (and (uiop:string-prefix-p "/assets/" path)
         (versioned-path-p path (getf env :query-string)))))

(defparameter *asset-cache-middleware*
  (with-args *cache-control*
    :rules `((versioned-asset-p ,*immutable-cache-control* :status (200 304))
             ("/assets/" ,*revalidate-cache-control* :status (200 304)))
    :override t))
