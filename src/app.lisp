(defpackage #:hp
  (:nicknames #:hp/app)
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view))
  (:local-nicknames (#:cmp #:hp/components/**/*))
  (:import-from #:lack.middleware.accesslog
                #:*lack-middleware-accesslog*)
  (:export #:start
           #:stop
           #:update))
(in-package #:hp)

(defparameter *app* (jg:make-app :address "localhost"
                                 :port 3000))

(defmethod jg:not-found ((app jg:app))
  (view:render-page (cmp:not-found-page)
                     :status :not-found
                     :title "404 Not Found"
                     :description "お探しのページは見つかりませんでした。"))

(defun update ()
  (jg:clear-middlewares *app*)
  (jg:install-middleware *app* *lack-middleware-accesslog*)
  (jg:static-path *app* "/public/" "public/")
  (fbr:assign-routes *app*
                     :system "hp"
                     :directory "src/routes"))
(update)

(defun start ()
  (jg:start *app*))

(defun stop ()
  (jg:stop *app*))
