(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:define-list-client
                #:define-object-client)
  (:import-from #:website/lib/env
                #:microcms-service-domain
                #:microcms-api-key)
  (:export #:get-blog-list
           #:get-blog-detail
           #:get-about
           #:get-work))
(in-package :website/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(define-object-client about)
(define-object-client work)
(define-list-client blog)
