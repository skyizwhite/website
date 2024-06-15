(defpackage #:hp/middlewares/recoverer
  (:use #:cl)
  (:local-nicknames (#:tb #:trivial-backtrace))
  (:local-nicknames (#:env #:hp/env))
  (:export #:*recoverer*))
(in-package #:hp/middlewares/recoverer)

(defun message (condition)
  (if (env:dev-mode-p)
      (tb:print-backtrace condition :output nil)
      "Internal Server Error"))

(defparameter *recoverer*
  (lambda (app)
    (lambda (env)
      (handler-case
          (funcall app env)
        (error (c)
          (log:error "Unhandled error caught: ~a" c)
          `(500 (:content-type "text/plain")
                (,(message c))))))))
