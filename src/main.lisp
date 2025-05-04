(defpackage #:website
  (:nicknames #:website/main)
  (:use #:cl)
  (:import-from #:clack)
  (:import-from #:website/app
                #:*app*)
  (:export #:start
           #:stop
           #:reload))
(in-package #:website)

(defparameter *server* nil)

(defun start ()
  (when *server*
    (restart-case (error "Server is already running.")
      (restart-server ()
        :report "Restart the server"
        (stop))))
  (setf *server* (clack:clackup *app*
                                :server :hunchentoot
                                :address "localhost"
                                :port 3000)))

(defun stop ()
  (when *server*
    (clack:stop *server*)
    (format t "Server stopped~%")
    (setf *server* nil)))

(defun reload ()
  (stop)
  (ql:quickload :website/app)
  (start))
