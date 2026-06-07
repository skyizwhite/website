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

(defparameter *cookie-name* "liked_blogs"
  "Name of the cookie tracking which blog posts this visitor has liked.")

;;; Pure helpers — the cookie value is a comma-separated list of blog ids.

(defun parse-liked-ids (value)
  "Parse a cookie VALUE into a list of blog ids. NIL or \"\" yields NIL."
  (when (and value (plusp (length value)))
    (remove "" (uiop:split-string value :separator '(#\,)) :test #'string=)))

(defun serialize-liked-ids (ids)
  "Render a list of blog IDS back into a cookie value string."
  (format nil "~{~a~^,~}" ids))

(defun liked-id-p (id ids)
  "Is blog ID present in the list IDS?"
  (and (member id ids :test #'string=) t))

(defun add-liked-id (id ids)
  "Return IDS with ID appended, unless it is already present."
  (if (liked-id-p id ids)
      ids
      (append ids (list id))))

;;; Request/response glue.

(defun liked-post-p (blog-id)
  "Has the current visitor already liked BLOG-ID, per their cookie?"
  (liked-id-p blog-id (parse-liked-ids (get-cookie *cookie-name*))))

(defun mark-post-liked (blog-id)
  "Record BLOG-ID as liked in the visitor's cookie."
  (let ((ids (add-liked-id blog-id
                           (parse-liked-ids (get-cookie *cookie-name*)))))
    (set-cookie *cookie-name* (serialize-liked-ids ids)
                :secure (not (dev-mode-p)))))
