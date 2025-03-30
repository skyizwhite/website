(defpackage #:hp/app
  (:use #:cl)
  (:import-from #:jingle
                #:make-app
                #:install-middleware
                #:static-path
                #:configure)
  (:import-from #:ningle-fbr
                #:set-routes)
  (:import-from #:hp/middlewares/recoverer
                #:*recoverer*)
  (:import-from #:lack-mw
                #:*trim-trailing-slash*)
  (:import-from #:hp/renderer)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app*
  (let ((app (make-app)))
    (set-routes app :system :hp :target-dir-path "routes")
    (install-middleware app *recoverer*)
    (install-middleware app *trim-trailing-slash*)
    (static-path app "/img/" "static/img/")
    (static-path app "/style/" "static/style/")
    (configure app)))

*app*
