(defpackage #:website
  (:nicknames #:website/main)
  (:use #:cl)
  (:import-from #:clack)
  (:import-from #:website/app
                #:*app*)
  (:import-from #:shun
                #:renew-build-id)
  (:import-from #:website/koya
                #:deploy-schema)
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

(defun serve ()
  (renew-build-id)
  (clack:clackup *app* :server :woo :address "0.0.0.0" :port 3000 :debug nil :use-thread nil)
  0)

(defun main ()
  (let ((command (second sb-ext:*posix-argv*)))
    (uiop:quit
     (cond ((null command) (serve))
           ((string= command "deploy-schema") (deploy-schema))
           (t (format *error-output* "~&Unknown command: ~a~%" command)
              2)))))

(defun save-executable (path)
  (setf ironclad::*os-prng-stream* nil)
  (sb-ext:save-lisp-and-die path :executable t :toplevel #'main :save-runtime-options t))
