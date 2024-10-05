(defpackage #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:env #:hp/env))
  (:local-nicknames (#:mw #:hp/middlewares/*))
  (:import-from #:hp/renderer)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app* (jg:make-app :address "localhost"
                                 :port env:*port*))

(jg:clear-middlewares *app*)
(jg:clear-routing-rules *app*)
(fbr:assign-routes *app* :system "hp" :directory "src/routes")
(jg:install-middleware *app* mw:*recoverer*)
(jg:install-middleware *app* mw:*path-normalizer*)
(jg:install-middleware *app* mw:*public-server*)
