(defpackage #:website/renderer
  (:use #:cl
        #:hsx
        #:trivia)
  (:import-from #:jingle
                #:set-response-header)
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
  (set-response-header :cache-control (if (string= (website-env) "dev")
                                          "private, no-store"
                                          "public, max-age=60"))
  (match result
    ((guard (or (list body metadata)
                body)
            (typep body 'element))
     (call-next-method app
                       (hsx:render-to-string
                        (hsx (html :lang "ja"
                               (head
                                 (~metadata :metadata metadata)
                                 (~scripts))
                               (body
                                 :hx-ext "head-support, response-targets, preload, alpine-morph"
                                 :hx-boost "true" :hx-target-404 "body" :hx-target-5* "body"
                                 (~layout body)))))))
    (_ (error "Invalid response form"))))
