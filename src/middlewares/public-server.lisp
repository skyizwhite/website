(defpackage #:hp/middlewares/public-server
  (:use #:cl)
  (:import-from #:lack.middleware.static
                #:*lack-middleware-static*)
  (:export #:*public-server*))
(in-package #:hp/middlewares/public-server)

(defun exist-asset-file-p (path)
  (let ((pathname (probe-file (concatenate 'string "public" path))))
    (and pathname (pathname-name pathname))))

(defparameter *public-server*
  (lambda (app)
    (funcall *lack-middleware-static*
             app
             :path (lambda (path)
                     (and (exist-asset-file-p path) path))
             :root (asdf:system-relative-pathname :hp "public/"))))
