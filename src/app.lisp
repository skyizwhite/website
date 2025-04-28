(defpackage #:hp/app
  (:use #:cl)
  (:import-from #:jingle
                #:make-app
                #:install-middleware
                #:static-path
                #:configure)
  (:import-from #:ningle-fbr
                #:set-routes)
  (:import-from #:lack-mw
                #:*trim-trailing-slash*)
  (:import-from #:clack-errors
                #:*clack-error-middleware*)
  (:import-from #:hp/env
                #:hp-env)
  (:import-from #:hp/renderer)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app*
  (let ((app (make-app)))
    (set-routes app :system :hp :target-dir-path "routes")
    (install-middleware app (lambda (app)
                              (funcall *clack-error-middleware*
                                       app
                                       :debug (string= (hp-env) "dev"))))
    (install-middleware app *trim-trailing-slash*)
    (static-path app "/img/" "static/img/")
    (static-path app "/style/" "static/style/")
    (configure app)))

*app*
