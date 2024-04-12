(defpackage #:hp/middlewares/public-files
  (:use #:cl)
  (:import-from #:lack.middleware.static
                #:*lack-middleware-static*)
  (:export #:*public-files*))
(in-package #:hp/middlewares/public-files)

(defun exist-public-file-p (path)
  (let ((pathname (probe-file (concatenate 'string "public" path))))
    (and pathname (pathname-name pathname))))

(defparameter *public-files*
  (lambda (app)
    (funcall *lack-middleware-static*
             app
             :path (lambda (path)
                     (and (exist-public-file-p path) path))
             :root (asdf:system-relative-pathname :hp "public/"))))
