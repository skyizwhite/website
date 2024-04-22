(defpackage #:hp/middlewares/path-normalizer
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:*path-normalizer*))
(in-package #:hp/middlewares/path-normalizer)

(defun has-trailing-slash-p (path)
  (and (not (string= path "/")) (re:scan "\/$" path)))

(defun remove-trailing-slash (path)
  (re:regex-replace "\/$" path ""))

(defparameter *path-normalizer*
  (lambda (app)
    (lambda (env)
      (let ((path (getf env :request-uri)))
        (if (has-trailing-slash-p path)
            `(308 (:location ,(remove-trailing-slash path)))
            (funcall app env))))))
