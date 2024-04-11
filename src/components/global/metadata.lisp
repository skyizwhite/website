(defpackage #:hp/components/global/metadata
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:metadata))
(in-package #:hp/components/global/metadata)

(pi:define-element metadata (title description)
  (pi:h
    (head
      (meta :charset "UTF-8")
      (title (format nil "~@[~a | ~]skyizwhite.dev" title))
      (meta
        :name "description"
        :content (or description "pakuの個人サイト"))
      (script :src "/public/js/htmx.js")
      (script :src "/public/js/htmx-ext/head-support.js")
      (script :src "/public/js/alpine.js" :defer t)
      (link :rel "stylesheet" :type "text/css" :href "/public/style/main.css"))))
