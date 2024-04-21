(defpackage #:hp/config/asset
  (:use #:cl)
  (:export #:asset-root
           #:asset-path))
(in-package #:hp/config/asset)

(defparameter *asset-roots*
  (list :style "/styles/"
        :script "/scripts/"
        :vendor "/vendor/"))

(defun asset-root (destination)
  (getf *asset-roots* destination))

(defun asset-path (destination path)
  (concatenate 'string (asset-root destination) path))
