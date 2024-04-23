(defpackage #:hp/view/asset
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:export #:asset-root
           #:defasset
           #:get-css-paths
           #:cmp-props))
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

(defun detect-data-props (html-str data-prop-name)
  (let* ((regex (format nil "(?<=~a=\")[^\"]*(?=\")" data-prop-name))
         (data-props (re:all-matches-as-strings regex html-str)))
    (remove-duplicates data-props :test #'string=)))

(defun get-css-paths (html-str)
  (mapcar (asset-path-under :css)
          (detect-data-props html-str "data-css")))

(defun cmp-props (&key css js x-data)
  (append (and css `(:data-css ,css))
          (and js x-data
               `(:ax-load t
                 :ax-load-src ,(asset-path :js js)
                 :x-ignore t
                 :x-data ,x-data))))
