(defpackage #:website/lib/liked-posts
  (:use #:cl)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/lib/cookie
                #:get-cookie
                #:set-cookie)
  (:export #:parse-liked-ids
           #:serialize-liked-ids
           #:liked-id-p
           #:add-liked-id
           #:liked-post-p
           #:mark-post-liked))
(in-package #:website/lib/liked-posts)

(defparameter *cookie-name* "liked_blogs")

(defun parse-liked-ids (value)
  (when (and value (plusp (length value)))
    (remove "" (uiop:split-string value :separator '(#\,)) :test #'string=)))

(defun serialize-liked-ids (ids)
  (format nil "~{~a~^,~}" ids))

(defun liked-id-p (id ids)
  (and (member id ids :test #'string=) t))

(defun add-liked-id (id ids)
  (if (liked-id-p id ids)
      ids
      (append ids (list id))))

(defun liked-post-p (blog-id)
  (liked-id-p blog-id (parse-liked-ids (get-cookie *cookie-name*))))

(defun mark-post-liked (blog-id)
  (let ((ids (add-liked-id blog-id
                           (parse-liked-ids (get-cookie *cookie-name*)))))
    (set-cookie *cookie-name* (serialize-liked-ids ids)
                :secure (not (dev-mode-p)))))
