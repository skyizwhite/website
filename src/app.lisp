(defpackage #:hp
  (:nicknames #:hp/app)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:cfg #:hp/config/env))
  (:local-nicknames (#:mw #:hp/middlewares/*))
  (:export #:start
           #:stop
           #:update))
(in-package #:hp)

(defparameter *app* (jg:make-app :address "localhost"
                                 :port cfg:*port*))

(defun start ()
  (jg:start *app*))

(defun stop ()
  (jg:stop *app*))

(defun setup ()
  (jg:clear-middlewares *app*)
  (jg:clear-routing-rules *app*)
  (fbr:assign-routes *app* :system "hp" :directory "src/routes")
  (jg:install-middleware *app* mw:*path-normalizer*)
  (jg:install-middleware *app* mw:*public-server*)
  (jg:install-middleware *app* mw:*recoverer*))

(defun update ()
  (stop)
  (ql:quickload :hp)
  (start))

(setup)
