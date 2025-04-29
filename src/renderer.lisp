(defpackage #:hp/renderer
  (:use #:cl
        #:hsx
        #:trivia)
  (:import-from #:jingle
                #:set-response-header)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:hp/lib/env
                #:hp-url
                #:hp-env)
  (:import-from #:hp/lib/metadata
                #:complete-metadata)
  (:import-from #:hp/ui/layout
                #:~layout))
(in-package #:hp/renderer)

(defmethod jingle:process-response ((app jingle:app) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (set-response-header :cache-control (if (string= (hp-env) "dev")
                                          "private, no-store"
                                          "public, max-age=60 s-maxage=300, stale-while-revalidate=86400, stale-if-error=86400"))
  (call-next-method app
                    (hsx:render-to-string
                     (match result
                       ((guard (or (list page metadata)
                                   page)
                               (typep page 'element))
                        (~layout (complete-metadata metadata)
                          page))
                       (_ (error "Invalid response form"))))))
