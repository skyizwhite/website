(defpackage #:hp/response
  (:use #:cl
        #:hsx)
  (:local-nicknames (#:jg #:jingle)))
(in-package #:hp/response)

(defcomp document (&key title description children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (meta :name "viewport" :content "width=device-width, initial-scale=1")
       (link :rel "icon" :href "/favicon.ico")
       (link :rel "apple-touch-icon" :href "/favicon.ico")
       (link :rel "stylesheet" :href "/dist.css")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.0/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-head-support@2.0.0/head-support.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.0/dist/cdn.min.js" :defer t)
       (title (format nil "~@[~a - ~]skyizwhite.dev" title))
       (meta
         :name "description"
         :content (or description "pakuの個人サイト"))
       (body :hx-ext "head-support"
         (main :class "container mx-auto"
           children))))))

(defmethod jg:process-response ((app jg:app) result)
  (jg:set-response-header :content-type "text/html; charset=utf-8")
  (call-next-method app
                    (hsx:render-to-string
                     (if (listp result)
                         (destructuring-bind (body metadata) result
                           (document metadata body))
                         (document result)))))
