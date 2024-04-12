(defpackage #:hp/middleware
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:import-from #:lack.middleware.static
                #:*lack-middleware-static*)
  (:export #:*public-files*))
(in-package #:hp/middleware)

(defun exist-public-file-p (path)
  (let ((pathname (probe-file (concatenate 'string "public" path))))
    (and pathname (pathname-name pathname))))

(defparameter *public-files*
  (lambda (app)
    (funcall *lack-middleware-static*
             app
             :path (lambda (path)
                     (if (exist-public-file-p path) 
                         path
                         nil))
             :root (asdf:system-relative-pathname :hp "public/"))))
