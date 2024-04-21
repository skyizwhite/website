(defpackage #:hp/middlewares/serve-assets
  (:use #:cl)
  (:import-from #:lack.middleware.static
                #:*lack-middleware-static*)
  (:export #:*serve-assets*))
(in-package #:hp/middlewares/serve-assets)

(defun exist-public-file-p (path)
  (let ((pathname (probe-file (concatenate 'string "assets" path))))
    (and pathname (pathname-name pathname))))

(defparameter *serve-assets*
  (lambda (app)
    (funcall *lack-middleware-static*
             app
             :path (lambda (path)
                     (and (exist-public-file-p path) path))
             :root (asdf:system-relative-pathname :hp "assets/"))))
