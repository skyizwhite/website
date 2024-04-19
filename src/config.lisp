(defpackage #:hp/config
  (:use #:cl)
  (:import-from #:log4cl)
  (:export #:dev-mode-p
           #:prod-mode-p))
(in-package #:hp/config)

(defparameter *env* (or (uiop:getenv "HP_ENV") "dev"))

(defun dev-mode-p ()
  (string= *env* "dev"))

(defun prod-mode-p ()
  (string= *env* "prod"))

(log:config :nofile)
