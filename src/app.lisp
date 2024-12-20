(defpackage #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:env #:hp/env))
  (:import-from #:hp/middlewares/recoverer
                #:*recoverer*)
  (:import-from #:hp/middlewares/trailing-slash
                #:*trim-trailing-slash*)
  (:import-from #:hp/middlewares/public-server
                #:*public-server*)
  (:import-from #:hp/renderer)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app* (jg:make-app :address env:*address*
                                 :port env:*port*))

(fbr:set-routes *app* :system :hp :target-dir-path "routes")
(jg:install-middleware *app* *recoverer*)
(jg:install-middleware *app* *trim-trailing-slash*)
(jg:install-middleware *app* *public-server*)
