(defpackage #:hp/view/asset
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:export #:asset-root
           #:defasset
           #:get-css-paths))
(in-package #:hp/view/asset)

(defun asset-root (kind)
  (getf cfg:*asset-roots* kind))

(defun asset-path (kind path)
  (concatenate 'string (asset-root kind) path))

(defun asset-path-under (kind)
  (lambda (path)
    (asset-path kind path)))

(defmacro defasset (name kind files)
  `(defparameter ,name
     (,(if (listp files) 'mapcar 'funcall)
      (asset-path-under ,kind) ',files)))

(defun detect-attr-vals (html attr)
  (let* ((regex (format nil "(?<=~a=\")[^\"]*(?=\")" attr))
         (vals (re:all-matches-as-strings regex html)))
    (remove-duplicates vals :test #'string=)))

(defun get-css-paths (html)
  (mapcar (asset-path-under :css)
          (detect-attr-vals html "data-css")))
