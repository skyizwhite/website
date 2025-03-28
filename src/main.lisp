(defpackage #:hp
  (:nicknames #:hp/main)
  (:use #:cl)
  (:import-from #:clack)
  (:import-from #:hp/app
                #:*app*)
  (:export #:start
           #:stop
           #:reload))
(in-package #:hp)

(defparameter *handler* nil)

(defun start ()
  (if *handler*
      (format t "The server is already running.~%")
      (setf *handler* (clack:clackup *app*
                                     :server :hunchentoot
                                     :address "localhost"
                                     :port 3000))))

(defun stop ()
  (if *handler*
      (progn
        (clack:stop *handler*)
        (setf *handler* nil))
      (format t "The server is not running.~%")))

(defun reload ()
  (stop)
  (ql:quickload :hp/app)
  (start))
