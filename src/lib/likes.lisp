(defpackage #:website/lib/likes
  (:use #:cl)
  (:import-from #:redis)
  (:import-from #:website/lib/env
                #:redis-host
                #:redis-port)
  (:import-from #:website/lib/cms
                #:fetch-legacy-blog-likes)
  (:export #:likes-key
           #:fetch-blog-likes
           #:increment-blog-likes))
(in-package #:website/lib/likes)

(defun likes-key (blog-id)
  "Redis key holding the like count of BLOG-ID."
  (format nil "blog:~a:likes" blog-id))

;;; Connection glue. Each call opens a short-lived connection, which
;;; keeps the code thread-safe under Hunchentoot and trivially correct
;;; under Woo; the Redis service sits on the same Docker network.

(defun call-with-redis (thunk)
  (redis:with-connection (:host (redis-host)
                          :port (parse-integer (redis-port)))
    (funcall thunk)))

(defmacro with-redis (&body body)
  `(call-with-redis (lambda () ,@body)))

;;; Storage.

(defun seed-blog-likes (blog-id)
  "Copy the legacy microCMS like count into Redis unless a count is
already there. SETNX keeps a like that raced in from being overwritten."
  (red:setnx (likes-key blog-id) (fetch-legacy-blog-likes blog-id)))

(defun fetch-blog-likes (blog-id)
  "Current like count of BLOG-ID. Signals `microcms-error' 404 for an
unknown post that has never been counted."
  (with-redis
    (let ((value (red:get (likes-key blog-id))))
      (cond (value (parse-integer value))
            (t (seed-blog-likes blog-id)
               (parse-integer (red:get (likes-key blog-id))))))))

(defun increment-blog-likes (blog-id)
  "Add one like to BLOG-ID and return the new count."
  (with-redis
    (let ((key (likes-key blog-id)))
      (unless (red:exists key)
        (seed-blog-likes blog-id))
      (red:incr key))))
