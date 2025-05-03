(defpackage #:website/renderer
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:website/lib/env
                #:website-env)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/scripts
                #:~scripts)
  (:import-from #:website/components/layout
                #:~layout))
(in-package #:website/renderer)

(defmethod jingle:process-response ((app jingle:app) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (when (eq (request-method *request*) :get)
    (set-response-header :cache-control (cond ((string= (website-env) "dev")
                                               "private, no-store")
                                              ((eq (context :cache) :static)
                                               "public, max-age=60, s-maxage=604800")
                                              ((eq (context :cache) :dynamic)
                                               "public, max-age=60")
                                              (t
                                               "private, no-store"))))
  
  (call-next-method app
                    (render-to-string
                     (hsx (html :lang "ja"
                            (head
                              (~metadata :metadata (context :metadata))
                              (~scripts))
                            (body
                              :hx-ext "head-support, response-targets, preload"
                              :hx-boost "true" :hx-target-404 "body" :hx-target-5* "body"
                              (~layout result)))))))
