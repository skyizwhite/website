(defpackage #:hp/middlewares/accesslog
  (:use #:cl)
  (:import-from #:lack.middleware.accesslog
                #:*lack-middleware-accesslog*)
  (:import-from #:log4cl)
  (:export *accesslog*))
(in-package #:hp/middlewares/accesslog)

(defparameter *accesslog*
  (lambda (app)
    (funcall *lack-middleware-accesslog*
             app
             :logger (lambda (message)
                       (log:info message)))))
