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

(defun start ()
  (jg:start *app*))

(defun stop ()
  (jg:stop *app*))

(defun update ()
  (stop)
  (ql:quickload :hp/app)
  (start))
