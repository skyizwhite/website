(defpackage #:website/lib/likes
  (:use #:cl)
  (:import-from #:redis)
  (:import-from #:website/lib/env
                #:redis-host
                #:redis-port)
  (:export #:likes-key
           #:fetch-blog-likes
           #:increment-blog-likes))
(in-package #:website/lib/likes)

(defun likes-key (blog-id)
  (format nil "blog:~a:likes" blog-id))

(defun call-with-redis (thunk)
  (redis:with-connection (:host (redis-host)
                          :port (parse-integer (redis-port)))
    (funcall thunk)))

(defmacro with-redis (&body body)
  `(call-with-redis (lambda () ,@body)))

(defun fetch-blog-likes (blog-id)
  (with-redis
    (let ((value (red:get (likes-key blog-id))))
      (if value (parse-integer value) 0))))

(defun increment-blog-likes (blog-id)
  (with-redis
    (red:incr (likes-key blog-id))))
