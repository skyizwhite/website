(defpackage #:website/renderer
  (:use #:cl
        #:hsx
        #:trivia)
  (:import-from #:jingle
                #:set-response-header)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:website/lib/env
                #:website-url
                #:website-env)
  (:import-from #:website/components/layout
                #:~layout))
(in-package #:website/renderer)

(defun set-cache-control (strategy)
  (set-response-header :cache-control
                       (if (string= (website-env) "dev")
                           "private, no-store"
                           (cond 
                             ((eq strategy :static) "public, max-age=60, s-maxage=31536000")
                             ((eq strategy :dynamic) "public, max-age=60")
                             (t "private, no-store")))))

(defmethod jingle:process-response ((app jingle:app) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (match result
    ((plist :body body
            :metadata metadata
            :cache cache
            :partial partial)
     (set-cache-control cache)
     (call-next-method app                         
                       (hsx:render-to-string
                        (if partial
                            body
                            (~layout :metadata metadata
                              body)))))
    (_ (error "Invalid response form"))))
