(defpackage #:hp/config/env
  (:use #:cl)
  (:export #:dev-mode-p
           #:prod-mode-p
           #:*port*))
(in-package #:hp/config/env)

(defmacro defenv (name env &key default parser)
  (let ((env-val (gensym "val")))
    `(defparameter ,name
       (let ((,env-val (uiop:getenv ,env)))
         (if ,env-val
             (funcall ,(or parser '#'identity) ,env-val)
             ,default)))))

(defenv *env*  "HP_ENV"  :default "dev")
(defenv *port* "HP_PORT" :default 3000 :parser #'parse-integer)

(defun dev-mode-p ()
  (string= *env* "dev"))

(defun prod-mode-p ()
  (string= *env* "prod"))
