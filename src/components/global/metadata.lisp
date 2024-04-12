(defpackage #:hp/components/global/metadata
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:metadata))
(in-package #:hp/components/global/metadata)

(pi:define-element metadata (title description)
  (pi:h
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
        :content (or description "pakuの個人サイト")))))
