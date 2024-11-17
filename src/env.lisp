(defpackage #:hp/env
  (:use #:cl)
  (:export #:dev-mode-p
           #:prod-mode-p
           #:*port*
           #:*address*))
(in-package #:hp/env)

(defmacro defenv (name env &key default parser)
  (let ((env-val (gensym "env-val")))
    `(defparameter ,name
       (let ((,env-val (uiop:getenv ,env)))
         (if ,env-val
             (funcall ,(or parser '#'identity) ,env-val)
             ,default)))))

(defenv *env* "HP_ENV" :default "dev")
(defenv *address* "HP_ADDRESS" :default "localhost")
(defenv *port* "HP_PORT" :default 3000 :parser #'parse-integer)

(defun dev-mode-p ()
  (string= *env* "dev"))

(defun prod-mode-p ()
  (string= *env* "prod"))
