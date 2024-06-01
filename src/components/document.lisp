(defpackage #:hp/components/document
  (:use #:cl
        #:hsx)
  (:import-from #:hp/view/asset
                #:defasset)
  (:export #:document))
(in-package #:hp/components/document)

(defasset *htmx* :vendor "htmx@1.9.12.js")
(defasset *htmx-exts* :htmx-ext
  ("alpine-morph@1.9.12.js"
   "head-support@1.9.12.js"))

(defasset *alpine* :vendor "alpine@3.13.8.js")
(defasset *alpine-exts* :alpine-ext
  ("morph@3.13.8.js"
   "persist@3.13.8.js"))
(defasset *alpine-store* :root "store.js")

(defasset *global-css* :root "global.css")
(defasset *dist-css* :root "dist.css")

(defcomp document (&key title description children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (script :src *htmx*)
       (mapcar (lambda (path) (script :src path))
               *htmx-exts*)
       (mapcar (lambda (path) (script :src path :defer t))
               *alpine-exts*)
       (script :src *alpine-store* :defer t)
       (script :src *alpine* :defer t)
       (style
         "@import url('https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap');")
       (link :rel "stylesheet" :type "text/css" :href *global-css*)
       (link :rel "stylesheet" :type "text/css" :href *dist-css*)
       (title (format nil "~@[~a - ~]skyizwhite.dev" title))
       (meta
         :name "description"
         :content (or description "pakuの個人サイト")))
     children)))
