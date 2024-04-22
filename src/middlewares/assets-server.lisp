(defpackage #:hp/middlewares/assets-server
  (:use #:cl)
  (:import-from #:lack.middleware.static
                #:*lack-middleware-static*)
  (:export #:*assets-server*))
(in-package #:hp/middlewares/assets-server)

(defun exist-public-file-p (path)
  (let ((pathname (probe-file (concatenate 'string "assets" path))))
    (and pathname (pathname-name pathname))))

(defparameter *assets-server*
  (lambda (app)
    (funcall *lack-middleware-static*
             app
             :path (lambda (path)
                     (and (exist-public-file-p path) path))
             :root (asdf:system-relative-pathname :hp "assets/"))))
