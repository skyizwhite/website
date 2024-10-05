(defpackage #:hp
  (:nicknames #:hp/main)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:env #:hp/env))
  (:import-from #:hp/app
                #:*app*)
  (:export #:start
           #:stop
           #:update))
(in-package #:hp)

(defparameter *watch-process* nil)

(defun start ()
  (when (env:dev-mode-p)
    (setf *watch-process* (uiop:launch-program "make watch")))
  (jg:start *app*))

(defun stop ()
  (when (env:dev-mode-p)
    (uiop:terminate-process *watch-process*))
  (jg:stop *app*))

(defun update ()
  (stop)
  (ql:quickload :hp/app)
  (start))
