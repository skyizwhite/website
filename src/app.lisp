(defpackage #:hp
  (:nicknames #:hp/app)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:env #:hp/env))
  (:local-nicknames (#:mw #:hp/middlewares/*))
  (:export #:start
           #:stop
           #:update))
(in-package #:hp)

(defparameter *watch-process* nil)

(defparameter *app* (jg:make-app :address "localhost"
                                 :port env:*port*))

(defun start ()
  (when (env:dev-mode-p)
    (setf *watch-process* (uiop:launch-program "make watch")))
  (jg:start *app*))

(defun stop ()
  (when (env:dev-mode-p)
    (uiop:terminate-process *watch-process*))
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
