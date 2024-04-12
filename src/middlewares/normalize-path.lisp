(defpackage #:hp/middlewares/normalize-path
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:*normalize-path*))
(in-package #:hp/middlewares/normalize-path)

(defun has-trailing-slash-p (path)
  (and (not (string= path "/")) (re:scan "\/$" path)))

(defun remove-trailing-slash (path)
  (re:regex-replace "\/$" path ""))

(defparameter *normalize-path*
  (lambda (app)
    (lambda (env)
      (let ((path (getf env :request-uri)))
        (if (has-trailing-slash-p path)
            `(308 (:location ,(remove-trailing-slash path)))
            (funcall app env))))))
