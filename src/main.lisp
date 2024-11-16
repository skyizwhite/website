(defpackage #:hp
  (:nicknames #:hp/main)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:env #:hp/env))
  (:import-from #:hp/app
                #:*app*)
  (:export #:start
           #:stop
           #:reload))
(in-package #:hp)

(defun start ()
  (jg:start *app*)
  (when (env:dev-mode-p)
    (uiop:run-program (format nil "open http://~a:~a"
                              env:*address* env:*port*))))

(defun stop ()
  (jg:stop *app*))

(defun reload ()
  (stop)
  (ql:quickload :hp/app)
  (start))
