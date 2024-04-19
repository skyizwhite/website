(defpackage #:hp/view/components/document
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:local-nicknames (#:pi #:piccolo))
  (:export #:document))
(in-package #:hp/view/components/document)

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
                           (detect-data-props html-str "data-css")))

(defun get-js-links (html-str)
  (data-props->asset-links "/scripts/"
                           ".js"
                           (detect-data-props html-str "data-js")))

(pi:define-element scripts (srcs)
  (pi:h
    (<>
      (mapcar (lambda (src)
                (script :src src))
              srcs))))

(pi:define-element stylesheets (hrefs)
  (pi:h
    (<>
      (mapcar (lambda (href)
                (link :rel "stylesheet" :type "text/css" :href href))
              hrefs))))

(pi:define-element on-demand-assets (component)
  (let* ((pi:*escape-html* nil)
         (html-str (pi:elem-str component))
         (css-links (get-css-links html-str))
         (js-links (get-js-links html-str)))
    (pi:h
      (<>
        (stylesheets :hrefs css-links)
        (scripts :srcs js-links)))))

(pi:define-element document (title description)
  (pi:h
    (html :lang "ja"
      (head
        (meta :charset "UTF-8")
        (link :rel "stylesheet" :type "text/css" :href "/vendor/ress.css")
        (link :rel "stylesheet" :type "text/css" :href "/styles/global.css")
        (link :rel "preconnect" :href "https://fonts.googleapis.com")
        (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
        (link 
          :rel "stylesheet"
          :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap")
        (on-demand-assets :component pi:children)
        (script :src "/vendor/htmx@1.9.12.js")
        (script :src "/vendor/alpine@3.13.8.js" :defer t)
        (title (format nil "~@[~a - ~]skyizwhite.dev" title))
        (meta
          :name "description"
          :content (or description "pakuの個人サイト")))
      pi:children)))
