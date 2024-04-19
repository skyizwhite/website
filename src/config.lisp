(defpackage #:hp/config
  (:use #:cl)
  (:export #:*env*
           #:is-dev-p
           #:is-prod-p))
(in-package #:hp/config)

(defparameter *env* (or (uiop:getenv "HP_ENV") "dev"))

(defun is-dev-p ()
  (string= *env* "dev"))

(defun is-prod-p ()
  (string= *env* "prod"))
