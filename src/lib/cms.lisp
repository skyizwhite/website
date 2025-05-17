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
           #:get-works
           #:get-blog-list
           #:get-blog-detail))
(in-package #:website/lib/cms)

(setf microcms:*service-domain* (microcms-service-domain))
(setf microcms:*api-key* (microcms-api-key))

(defmacro memorize (name)
  (let ((origin (gensym)))
    `(progn
       (setf (fdefinition ',origin) (fdefinition ',name))
       (defcached ,name (&key query)
         (,origin :query query)))))

(define-object-client about)
(memorize get-about)

(define-object-client works)
(memorize get-works)

(define-list-client blog)
(memorize get-blog-list)
(memorize get-blog-detail)
