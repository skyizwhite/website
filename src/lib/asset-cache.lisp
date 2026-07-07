(defpackage #:website/lib/asset-cache
  (:use #:cl)
  (:export #:*asset-cache-middleware*))
(in-package #:website/lib/asset-cache)

(defparameter *cache-control* "public, max-age=31536000, immutable")

(defparameter *asset-cache-middleware*
  (lambda (app)
    (lambda (env)
      (let* ((asset-p (uiop:string-prefix-p "/assets" (getf env :path-info)))
             (res (funcall app env)))
        (when asset-p
          (setf (getf (second res) :cache-control) *cache-control*))
        res))))
