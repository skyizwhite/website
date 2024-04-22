(defpackage #:hp/middlewares/access-logger
  (:use #:cl)
  (:import-from #:lack.middleware.accesslog
                #:*lack-middleware-accesslog*)
  (:import-from #:log4cl)
  (:export *access-logger*))
(in-package #:hp/middlewares/access-logger)

(defparameter *access-logger*
  (lambda (app)
    (funcall *lack-middleware-accesslog*
             app
             :logger (lambda (message)
                       (log:info message)))))
