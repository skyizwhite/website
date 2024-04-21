(defpackage #:hp/view/asset
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:get-css-links
           #:asset-props))
(in-package #:hp/view/asset)

(defun detect-data-props (html-str data-prop-name)
  (remove-duplicates (re:all-matches-as-strings (format nil
                                                        "(?<=~a=\")[^\"]*(?=\")"
                                                        data-prop-name)
                                                html-str)
                     :test #'string=))

(defun data-props->asset-links (parent-path extension data-props)
  (mapcar (lambda (data-prop)
            (concatenate 'string parent-path data-prop extension))
          data-props))

(defun get-css-links (html-str)
  (data-props->asset-links "/styles/"
                           ".css"
                           (detect-data-props html-str "data-style")))

(defun asset-props (&key style script x-data)
  (append (and style `(:data-style ,style))
          (and script x-data
               `(:ax-load t
                 :ax-load-src ,(format nil "/scripts/~a.js" script)
                 :x-ignore t
                 :x-data ,x-data))))
