(defpackage #:hp/view/asset
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:*ress*
           #:*global-css*
           #:*global-js*
           #:*htmx*
           #:*htmx-extentions*
           #:*alpine*
           #:*alpine-extentions*
           #:asset-root
           #:get-css-paths
           #:asset-props))
(in-package #:hp/view/asset)

(defparameter *asset-roots*
  '(:style "/styles/"
    :script "/scripts/"
    :vendor "/vendor/"
    :htmx-ext "/vendor/htmx-ext/"
    :alpine-ext "/vendor/alpine-ext/"))

(defun asset-root (group)
  (getf *asset-roots* group))

(defun asset-path (group path)
  (concatenate 'string (asset-root group) path))

(defun asset-path-under (root)
  (lambda (ext)
    (asset-path root ext)))

(defmacro define-asset (name root &body files)
  `(defparameter ,name
     ,(if (rest files)
          `(mapcar (asset-path-under ,root) ',files)
          `(funcall (asset-path-under ,root) ,(car files)))))

(define-asset *ress* :vendor
  "ress@5.0.2.css")
(define-asset *global-css* :style
  "global.css")

(define-asset *global-js* :script
  "global.js")

(define-asset *htmx* :vendor
  "htmx@1.9.12.js")
(define-asset *htmx-extentions* :htmx-ext
  "alpine-morph@1.9.12.js"
  "head-support@1.9.12.js")

(define-asset *alpine* :vendor
  "alpine@3.13.8.js")
(define-asset *alpine-extentions* :alpine-ext
  "async-alpine@1.2.2.js"
  "persist@3.13.8.js"
  "morph@3.13.8.js")

(defun detect-data-props (html-str data-prop-name)
  (remove-duplicates (re:all-matches-as-strings (format nil
                                                        "(?<=~a=\")[^\"]*(?=\")"
                                                        data-prop-name)
                                                html-str)
                     :test #'string=))

(defun get-css-paths (html-str)
  (mapcar (lambda (data-prop)
            (asset-path :style data-prop))
          (detect-data-props html-str "data-style")))

(defun asset-props (&key style script x-data)
  (append (and style `(:data-style ,style))
          (and script x-data
               `(:ax-load t
                 :ax-load-src ,(asset-path :script script)
                 :x-ignore t
                 :x-data ,x-data))))
