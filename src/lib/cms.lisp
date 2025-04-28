(defpackage #:hp/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:define-list-client)
  (:import-from #:hp/lib/env
                #:microcms-service-domain
                #:microcms-api-key)
  (:export #:get-blog-list
           #:get-blog-detail))
(in-package :hp/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(define-list-client blog)
