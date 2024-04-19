(defpackage #:hp/middlewares/recovery
  (:use #:cl)
  (:export #:*recovery*))
(in-package #:hp/middlewares/recovery)

;;; TODO: insert logger

(defparameter *recovery*
  (lambda (app)
    (lambda (env)
      (handler-case
          (funcall app env)
        (error (c)
          `(500 (:content-type "text/plain")
                (,(format nil "Internal Server Error: ~a~%" c))))))))
