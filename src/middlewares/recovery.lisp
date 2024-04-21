(defpackage #:hp/middlewares/recovery
  (:use #:cl)
  (:import-from #:log4cl)
  (:local-nicknames (#:tb #:trivial-backtrace))
  (:local-nicknames (#:cfg #:hp/config/env))
  (:export #:*recovery*))
(in-package #:hp/middlewares/recovery)

(defun message (condition)
  (if (cfg:dev-mode-p)
      (tb:print-backtrace condition :output nil)
      "Internal Server Error"))

(defparameter *recovery*
  (lambda (app)
    (lambda (env)
      (handler-case
          (funcall app env)
        (error (c)
          (log:error "Unhandled error caught: ~a" c)
          `(500 (:content-type "text/plain")
                (,(message c))))))))
