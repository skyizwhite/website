(defpackage #:hp/middlewares/recovery
  (:use #:cl)
  (:import-from #:log4cl)
  (:export #:*recovery*))
(in-package #:hp/middlewares/recovery)

(defparameter *recovery*
  (lambda (app)
    (lambda (env)
      (handler-case
          (funcall app env)
        (error (c)
          (log:error "Unhandled error caught: ~a" c)
          `(500 (:content-type "text/plain")
                ("Internal Server Error")))))))
