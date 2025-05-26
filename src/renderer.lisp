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
    (let ((strategy (context :cache)))
      (cond ((dev-mode-p)
             (set-response-header :cache-control "private, no-store, must-revalidate"))
            ((eq strategy :ssr)
             (set-response-header :cache-control "public, max-age=0, must-revalidate"))
            ((eq strategy :isr)
             (set-response-header :cache-control "public, max-age=0, s-maxage=60, stale-while-revalidate=60"))
            ((eq strategy :sg)
             (set-response-header :cache-control "public, max-age=0, s-maxage=31536000, must-revalidate")))))
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
                                     (~layout result)))))))))
