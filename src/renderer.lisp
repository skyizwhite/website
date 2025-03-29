(defpackage #:hp/renderer
  (:use #:cl
        #:hsx
        #:trivia)
  (:import-from :jingle)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:hp/env
                #:hp-env))
(in-package #:hp/renderer)

(defun bust-cache (url)
  (format nil "~a?v=~a" url (if (string= (hp-env) "dev")
                                (get-universal-time)
                                #.(get-universal-time))))

(defparameter *metadata-template*
  (list :title (lambda (title)
                 (format nil "~@[~a - ~]~a" title "skyizwhite.dev"))
        :description "The personal homepage of Akira Tempaku (paku) - projects, thoughts, and more."
        :og-url "https://skyizwhite.dev"
        :og-type "website"
        :og-image "https://skyizwhite.dev/img/og.jpg"
        :og-image-width 1024
        :og-image-height 1024))

(defun complete-metadata (metadata)
  (loop 
    :for (key template) :on *metadata-template* by #'cddr
    :for value := (getf metadata key)
    :append (list key (if (functionp template)
                          (funcall template value)
                          (or value template)))))

(defcomp ~document (&key title
                         description
                         og-url
                         og-type
                         og-image
                         og-image-width
                         og-image-height
                         children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (meta :name "viewport" :content "width=device-width, initial-scale=1")
       (title title)
       (meta :name "description" :content description)
       (meta :property "og:title" :content title)
       (meta :property "og:description" :content description)
       (meta :property "og:url" :content og-url)
       (meta :property "og:type" :content og-type)
       (meta :property "og:site_name" :content "skyizwhite.dev")
       (meta :property "og:image" :content og-image)
       (meta :property "og:image:width" :content og-image-width)
       (meta :property "og:image:height" :content og-image-height)
       (link :rel "icon" :type "image/x-icon" :href "/img/favicon.ico")
       (link :rel "apple-touch-icon" :href "/img/favicon.ico")
       (link :rel "stylesheet" :href (bust-cache "/style/dist.css"))
       (link :rel "preconnect" :href "https://fonts.googleapis.com")
       (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
       (link :rel "stylesheet" :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP&display=swap")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.0/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-head-support@2.0.0/head-support.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-response-targets@2.0.0/response-targets.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.0/dist/cdn.min.js" :defer t))
     (body
       :hx-ext "head-support, response-targets"
       :hx-boost "true" :hx-target-404 "body" :hx-target-5* "body"
       :class "h-[100svh] flex flex-col"
       (main :class "flex-1 h-full"
         children)))))

(defmethod jingle:process-response ((app jingle:app) result)
  (jingle:set-response-header :content-type "text/html; charset=utf-8")
  (when (string= (hp-env) "dev")
    (jingle:set-response-header :cache-control "no-store, no-cache, must-revalidate")
    (jingle:set-response-header :pragma "no-cache")
    (jingle:set-response-header :expires "0"))
  (call-next-method app
                    (hsx:render-to-string
                     (match result
                       ((guard (or (list element metadata)
                                   element)
                               (typep element 'element))
                        (~document (complete-metadata metadata)
                          element))
                       (_ (error "Invalid response form"))))))
