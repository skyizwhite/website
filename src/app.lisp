(defpackage #:hp/app
  (:use #:cl)
  (:import-from #:jingle
                #:make-app
                #:install-middleware
                #:configure)
  (:import-from #:ningle-fbr
                #:set-routes)
  (:import-from #:hp/middlewares/recoverer
                #:*recoverer*)
  (:import-from #:hp/middlewares/trailing-slash
                #:*trim-trailing-slash*)
  (:import-from #:hp/middlewares/public-server
                #:*public-server*)
  (:import-from #:hp/renderer)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app*
  (let ((app (make-app)))
    (set-routes app :system :hp :target-dir-path "routes")
    (install-middleware app *recoverer*)
    (install-middleware app *trim-trailing-slash*)
    (install-middleware app *public-server*)
    (configure app)))

*app*
