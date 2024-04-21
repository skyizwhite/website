(defpackage #:hp/view/asset
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:export #:get-css-links
           #:asset-props))
(in-package #:hp/view/asset)

(defun detect-data-props (html-str data-prop-name)
  (remove-duplicates (re:all-matches-as-strings (format nil
                                                        "(?<=~a=\")[^\"]*(?=\")"
                                                        data-prop-name)
                                                html-str)
                     :test #'string=))

(defun get-css-links (html-str)
  (mapcar (lambda (data-prop)
            (cfg:asset-path :style data-prop))
          (detect-data-props html-str "data-style")))

(defun asset-props (&key style script x-data)
  (append (and style `(:data-style ,style))
          (and script x-data
               `(:ax-load t
                 :ax-load-src ,(cfg:asset-path :script script)
                 :x-ignore t
                 :x-data ,x-data))))
