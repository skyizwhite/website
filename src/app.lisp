(defpackage #:website/app
  (:use #:cl
        #:jingle
        #:hsx)
  (:import-from #:lack
                #:builder)
  (:import-from #:jonathan
                #:to-json)
  (:import-from #:ningle-actions
                #:*actions-app*
                #:*actions-middleware*)
  (:import-from #:ningle-fbr
                #:set-routes)
  (:import-from #:lack-mw
                #:with-args
                #:mw-except
                #:*accesslog*
                #:*recovery*
                #:*mount*
                #:*static*
                #:*trim-trailing-slash*)
  (:import-from #:shun
                #:*bypass*
                #:*mw-shun*)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/lib/asset-cache
                #:*asset-cache-middleware*)
  (:import-from #:website/document
                #:~document)
  (:import-from #:website/helper
                #:preload-link)
  (:export #:*app*))
(in-package #:website/app)

(defmethod jingle:process-response :around ((app (eql *actions-app*)) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (call-next-method app (and result (hsx:render-to-string (hsx result)))))

(setf *bypass* (dev-mode-p))

(defparameter *page-app* (make-app))
(set-routes *page-app* :system :website :dir "pages")

(defmethod jingle:process-response :around ((app (eql *page-app*)) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (set-response-header :link (preload-link))
  (call-next-method app (hsx:render-to-string (hsx (~document result)))))

(defparameter *api-app* (make-app))
(set-routes *api-app* :system :website :dir "api")

(defmethod jingle:process-response :around ((app (eql *api-app*)) result)
  (set-response-header :content-type "application/json; charset=utf-8")
  (call-next-method app (to-json result)))

(defparameter *app*
  (builder
   *accesslog*
   (with-args *recovery* :dev-mode (dev-mode-p))
   *trim-trailing-slash*
   (mw-except '("/assets/*" "/actions/*" "/api/*") *mw-shun*)
   *asset-cache-middleware*
   (with-args *static* :path "/assets/" :root "assets/")
   *actions-middleware*
   (with-args *mount* "/api" *api-app*)
   *page-app*))

*app*
