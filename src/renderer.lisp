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
  (:import-from #:hp/ui/layout
                #:~layout))
(in-package #:hp/renderer)

(defun set-cache-control (strategy)
  (set-response-header :cache-control
                       (if (string= (hp-env) "dev")
                           "private, no-store"
                           (cond 
                             ((eq strategy :static) "public, max-age=31536000, immutable")
                             ((eq strategy :dynamic) "public, max-age=60")
                             (t "private, no-store")))))

(defmethod jingle:process-response ((app jingle:app) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (call-next-method app
                    (hsx:render-to-string
                     (match result
                       ((plist :body body
                               :metadata metadata
                               :cache cache)
                        (progn
                          (set-cache-control cache)
                          (~layout :metadata metadata
                            body)))
                       (_ (error "Invalid response form"))))))
