(defpackage #:hp
  (:nicknames #:hp/app)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:cfg #:hp/config/*))
  (:local-nicknames (#:asset #:hp/view/asset))
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
  (jg:install-middleware *app* mw:*recovery*)
  (jg:install-middleware *app* mw:*serve-assets*)
  (jg:install-middleware *app* mw:*normalize-path*)
  (jg:install-middleware *app* mw:*accesslog*)
  (jg:install-middleware *app* mw:*block-unsupported-browser*))

(defun update ()
  (stop)
  (setup)
  (start))

(setup)
