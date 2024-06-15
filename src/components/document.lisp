(defpackage #:hp/components/document
  (:use #:cl
        #:hsx)
  (:export #:document))
(in-package #:hp/components/document)

(defcomp document (&key title description children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (meta :name "viewport" :content "width=device-width, initial-scale=1")
       (meta :name "color-scheme" :content "light dark")
       (link :rel "stylesheet" :href "https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@1.9.12/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@1.9.12/dist/ext/head-support.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.0/dist/cdn.min.js" :defer t)
       (title (format nil "~@[~a - ~]skyizwhite.dev" title))
       (meta
         :name "description"
         :content (or description "pakuの個人サイト")))
     children)))
