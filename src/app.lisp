(defpackage #:website/app
  (:use #:cl
        #:jingle
        #:hsx)
  (:import-from #:jonathan
                #:to-json)
  (:import-from #:ningle-fbr
                #:set-routes)
  (:import-from #:lack/middleware/mount
                #:*lack-middleware-mount*)
  (:import-from #:lack-mw
                #:*trim-trailing-slash*)
  (:import-from #:clack-errors
                #:*clack-error-middleware*)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/document
                #:~document)
  (:export #:*app*))
(in-package #:website/app)

(defparameter *page-app* (make-app))
(set-routes *page-app* :system :website :target-dir-path "pages")

(defmethod jingle:process-response :around ((app (eql *page-app*)) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (call-next-method app (render-to-string
                         (hsx (~document result)))))

(defparameter *api-app* (make-app))
(set-routes *api-app* :system :website :target-dir-path "api")

(defmethod jingle:process-response :around ((app (eql *api-app*)) result)
  (set-response-header :content-type "application/json; charset=utf-8") 
  (call-next-method app (to-json result)))

(defun with-args (middleware &rest args)
  (lambda (app)
    (apply middleware app args)))

(defparameter *app*
  (progn
    (clear-middlewares *page-app*)
    (install-middleware *page-app* (with-args *clack-error-middleware* :debug (dev-mode-p)))
    (install-middleware *page-app* *trim-trailing-slash*)
    (static-path *page-app* "/assets/" "assets/")
    (install-middleware *page-app* (with-args *lack-middleware-mount* "/api" *api-app*))
    (configure *page-app*)))

*app*
