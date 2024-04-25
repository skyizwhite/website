(defpackage #:hp/view/asset
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:export #:asset-root
           #:defasset))
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
