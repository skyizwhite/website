(defpackage #:website/lib/cms
  (:use #:cl)
  (:import-from #:microcms
                #:define-list-client
                #:define-object-client)
  (:import-from #:function-cache
                #:defcached)
  (:import-from #:website/lib/env
                #:microcms-service-domain
                #:microcms-api-key)
  (:export #:get-about
           #:get-work
           #:get-blog-list
           #:get-blog-detail))
(in-package #:website/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(defmacro memorize (name timeout)
  (let ((origin (gensym)))
    `(progn
       (setf (fdefinition ',origin) (fdefinition ',name))
       (defcached (,name :timeout ,timeout) (&key query)
         (,origin :query query)))))

(define-object-client about)
(memorize get-about 60)

(define-object-client work)
(memorize get-work 60)

(define-list-client blog)
(memorize get-blog-list 60)
(memorize get-blog-detail 60)
