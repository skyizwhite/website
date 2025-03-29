(defpackage #:hp/env
  (:use #:cl)
  (:import-from #:cl-dotenv
                #:load-env)
  (:export #:hp-env))
(in-package #:hp/env)

(load-env (merge-pathnames "./.env"))

(defmacro env-var (name var)
  `(defun ,name ()
     (or (uiop:getenv ,var) "")))

(env-var hp-env "HP_ENV")
