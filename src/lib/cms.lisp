(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:define-list-client
                #:define-object-client)
  (:import-from #:website/lib/env
                #:microcms-service-domain
                #:microcms-api-key)
  (:import-from #:website/lib/cache
                #:memorize)
  (:export #:get-about
           #:get-works
           #:get-blog-list
           #:get-blog-detail))
(in-package #:website/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(define-object-client about)
(memorize get-about)

(define-object-client works)
(memorize get-works)

(define-list-client blog)
(memorize get-blog-list)
(memorize get-blog-detail)
