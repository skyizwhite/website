(defpackage #:website/api/health
  (:use #:cl
        #:jingle)
  (:export #:@get))
(in-package #:website/api/health)

(defun @get (params)
  (declare (ignore params))
  (set-response-header :cache-control "private, no-store")
  '(:|status| "ok"))
