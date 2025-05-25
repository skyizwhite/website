(defpackage #:website/renderer
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:jonathan
                #:to-json)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/helper
                #:api-request-p)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/scripts
                #:~scripts)
  (:import-from #:website/components/layout
                #:~layout))
(in-package #:website/renderer)

(defmethod jingle:process-response :around ((app jingle:app) result)
  (when (eq (request-method *request*) :get)
    (if (or (context :no-cache) (dev-mode-p))
        (set-response-header :cache-control "private, no-store, must-revalidate")
        (set-response-header :cache-control "public, max-age=60")))
  (cond ((api-request-p)
         (set-response-header :content-type "application/json; charset=utf-8") 
         (call-next-method app (to-json result)))
        (t
         (set-response-header :content-type "text/html; charset=utf-8")
         (call-next-method app
                           (render-to-string
                            (hsx (html :lang "en"
                                   (head
                                     (~metadata :metadata (context :metadata))
                                     (~scripts))
                                   (body
                                     :hx-ext (clsx "head-support, response-targets,"
                                                   (and (not (dev-mode-p)) "preload"))
                                     :hx-boost "true" :hx-swap "transition:true"
                                     :hx-target-404 "body" :hx-target-5* "body"
                                     :class "bg-stone-100"
                                     (~layout result)))))))))
