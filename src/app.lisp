(defpackage #:website/app
  (:use #:cl
        #:jingle)
  (:import-from #:ningle-fbr
                #:set-routes)
  (:import-from #:lack-mw
                #:*trim-trailing-slash*)
  (:import-from #:clack-errors
                #:*clack-error-middleware*)
  (:import-from #:website/lib/env
                #:website-env)
  (:import-from #:website/renderer)
  (:export #:*app*))
(in-package #:website/app)

(defparameter *app*
  (let ((app (make-app)))
    (set-routes app :system :website :target-dir-path "routes")
    (install-middleware app (lambda (app)
                              (funcall *clack-error-middleware*
                                       app
                                       :debug (string= (website-env) "dev"))))
    (install-middleware app *trim-trailing-slash*)
    (static-path app "/img/" "static/img/")
    (static-path app "/style/" "static/style/")
    (configure app)))

*app*
