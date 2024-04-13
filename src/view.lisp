(defpackage #:hp/view
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:export #:render))
(in-package #:hp/view)

(pi:define-element document (title description)
  (pi:h
    (html :lang "ja"
      (head
        (meta :charset "UTF-8")
        (script :src "/scripts/htmx.js")
        (script :src "/scripts/htmx-ext/head-support.js")
        (script :src "/scripts/alpine.js" :defer t)
        (link :rel "stylesheet" :type "text/css" :href "/styles/ress.css")
        (link :rel "stylesheet" :type "text/css" :href "/styles/global.css")
        (link :rel "preconnect" :href "https://fonts.googleapis.com")
        (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
        (link 
          :rel "stylesheet"
          :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap")
        (title (format nil "~@[~a - ~]skyizwhite.dev" title))
        (meta
          :name "description"
          :content (or description "pakuの個人サイト")))
      (body :hx-ext "head-support"
        (main pi:children)))))

(defun render (page &key status metadata)
  (jg:with-html-response
    (and status (jg:set-response-status status))
    (pi:elem-str (document metadata page))))
