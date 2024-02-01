(defpackage :hp
  (:nicknames #:hp/main)
  (:use #:cl)
  (:import-from #:clack)
  (:import-from #:hp/app
                #:*app*)
  (:export #:start-server
           #:stop-server))
(in-package :hp)

(defparameter *server* nil)

(defun start-server ()
  (if *server*
      (format t "Server is already running.~%")
      (setf *server* (clack:clackup *app*
                                    :address "localhost"
                                    :port 3000))))

(defun stop-server ()
  (if *server*
      (prog1 
          (clack:stop *server*)
        (setf *server* nil))
      (format t "No servers running.~%")))
