(defpackage #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:env #:hp/env))
  (:local-nicknames (#:mw #:hp/middlewares/*))
  (:import-from #:hp/renderer)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app* (jg:make-app :address env:*address*
                                 :port env:*port*))

(fbr:assign-routes *app* :system "hp" :directory "src/routes")
(jg:install-middleware *app* mw:*recoverer*)
(jg:install-middleware *app* mw:*trim-trailing-slash*)
(jg:install-middleware *app* mw:*public-server*)
