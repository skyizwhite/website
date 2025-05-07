(defpackage #:website/renderer
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/scripts
                #:~scripts)
  (:import-from #:website/components/layout
                #:~layout))
(in-package #:website/renderer)

(defmethod jingle:process-response :around ((app jingle:app) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (when (eq (request-method *request*) :get)
    (set-response-header :cache-control "public, max-age=60"))
  (call-next-method app
                    (render-to-string
                     (hsx (html :lang "ja"
                            (head
                              (~metadata :metadata (context :metadata))
                              (~scripts))
                            (body
                              :hx-ext "head-support, response-targets, preload"
                              :hx-boost "true" :hx-swap "transition:true"
                              :hx-target-404 "body" :hx-target-5* "body"
                              (~layout result)))))))
