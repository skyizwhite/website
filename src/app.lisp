(defpackage #:hp
  (:nicknames #:hp/app)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:cfg #:hp/config))
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
  (fbr:assign-routes *app*
                     :system "hp"
                     :directory "src/routes")
  (jg:static-path *app* "/scripts/" "src/scripts/")
  (jg:static-path *app* "/styles/" "src/styles/")
  (jg:install-middleware *app* mw:*public-files*)
  (jg:install-middleware *app* mw:*recovery*)
  (jg:install-middleware *app* mw:*normalize-path*)
  (jg:install-middleware *app* mw:*accesslog*))

(defun update ()
  (stop)
  (setup)
  (start))

(setup)
