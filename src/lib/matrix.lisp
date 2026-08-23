(defpackage #:website/lib/matrix
  (:use #:cl)
  (:export #:*homeserver-host*
           #:*homeserver-port*
           #:*homeserver-base-url*
           #:*homeserver-delegation*))
(in-package #:website/lib/matrix)

(defparameter *homeserver-host* "matrix.skyizwhite.dev")

(defparameter *homeserver-port* 443)

(defparameter *homeserver-base-url*
  (format nil "https://~a" *homeserver-host*))

(defparameter *homeserver-delegation*
  (format nil "~a:~a" *homeserver-host* *homeserver-port*))
