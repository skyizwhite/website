(defpackage :hp
  (:nicknames #:hp/main)
  (:use #:cl)
  (:import-from #:clack)
  (:import-from #:lack)
  (:local-nicknames (#:pages #:hp/pages/**/*))
  (:export #:start-app
           #:stop-app))
(in-package :hp)

(defparameter *handler* nil)

(defun start-app ()
  (unless *handler*
    (setf *handler* (clack:clackup (lack:builder pages:*index-app*)
                                   :address "localhost"
                                   :port 3000))))

(defun stop-app ()
  (when *handler*
    (clack:stop *handler*)
    (setf *handler* nil)
    t))
