(defpackage #:hp
  (:nicknames #:hp/app)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:local-nicknames (#:cmp #:hp/components/**/*))
  (:local-nicknames (#:mw #:hp/middlewares/*))
  (:export #:start
           #:stop
           #:update))
(in-package #:hp)

(defparameter *app* (jg:make-app :address "localhost"
                                 :port 3000))

(defmethod jg:not-found ((app jg:app))
  (view:render (cmp:not-found-page)
               :status :not-found
               :title "404 Not Found"
               :description "お探しのページは見つかりませんでした。"))

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
  (jg:install-middleware *app* mw:*normalize-path*))

(defun update ()
  (stop)
  (setup)
  (start))

(setup)
