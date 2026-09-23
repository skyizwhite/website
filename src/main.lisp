(defpackage #:website
  (:nicknames #:website/main)
  (:use #:cl)
  (:import-from #:clack)
  (:import-from #:website/app
                #:*app*)
  (:import-from #:website/lib/etag
                #:renew-build-id)
  (:import-from #:website/koya
                #:deploy-at-startup)
  (:export #:start
           #:stop
           #:reload
           #:main
           #:save-executable))
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

(defun main ()
  "Entry point for a deployed process: deploy the schema to koya, then Woo on all
interfaces, in this thread, until SIGTERM or SIGINT."
  (renew-build-id)
  (deploy-at-startup)
  (clack:clackup *app* :server :woo :address "0.0.0.0" :port 3000 :debug nil :use-thread nil)
  (uiop:quit 0))

(defun save-executable (path)
  "Save the loaded site as an executable at PATH that runs MAIN, and exit."
  (setf ironclad::*os-prng-stream* nil)
  (sb-ext:save-lisp-and-die path :executable t :toplevel #'main :save-runtime-options t))
