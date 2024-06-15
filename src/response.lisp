(defpackage #:hp/response
  (:use #:cl
        #:hsx)
  (:local-nicknames (#:jg #:jingle))
  (:export #:response
           #:partial-response))
(in-package #:hp/response)

(defcomp document (&key title description children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (meta :name "viewport" :content "width=device-width, initial-scale=1")
       (link :rel "stylesheet" :href "https://cdn.jsdelivr.net/npm/uikit@3.21.5/dist/css/uikit.min.css")
       (script :src "https://cdn.jsdelivr.net/npm/uikit@3.21.5/dist/js/uikit.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@1.9.12/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@1.9.12/dist/ext/head-support.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.0/dist/cdn.min.js" :defer t)
       (title (format nil "~@[~a - ~]skyizwhite.dev" title))
       (meta
         :name "description"
         :content (or description "pakuの個人サイト"))
       (body :hx-ext "head-support"
         (main :class "uk-container"
           children))))))

(defun response (page &key status metadata)
  (jg:with-html-response
    (when status
      (jg:set-response-status status))
    (hsx:render-to-string (document metadata
                            page))))

(defun partial-response (component &key status)
  (jg:with-html-response
    (when status
      (jg:set-response-status status))
    (hsx:render-to-string component)))
