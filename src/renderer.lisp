(defpackage #:hp/renderer
  (:use #:cl
        #:hsx
        #:trivia)
  (:import-from #:jingle
                #:set-response-header)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:hp/env
                #:hp-url
                #:hp-env))
(in-package #:hp/renderer)

(defun path->url (path)
  (concatenate 'string
               (hp-url)
               (and (not (string= path "/")) path)))

(defparameter *metadata-template*
  (list :title (lambda (title) (format nil "~@[~a - ~]~a" title "skyizwhite.dev"))
        :description "The personal website of Akira Tempaku (paku) - projects, thoughts, and more."
        :canonical #'path->url
        :og-url #'path->url
        :og-type "website"
        :og-image (path->url "/img/og.jpg")
        :og-image-width 1024
        :og-image-height 1024))

(defun complete-metadata (metadata)
  (loop 
    :for (key template) :on *metadata-template* :by #'cddr
    :for value := (getf metadata key)
    :append (list key (if (functionp template)
                          (funcall template value)
                          (or value template)))))

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))

(defcomp ~document (&key title
                         description
                         canonical
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
       (link :rel "canonical" :href canonical)
       (link :rel "icon" :type "image/png" :href "/img/favicon-96x96.png" :sizes "96x96")
       (link :rel "icon" :type "image/svg+xml" :href "/img/favicon.svg")
       (link :rel "shortcut icon" :href "/img/favicon.ico")
       (link :rel "apple-touch-icon" :sizes "180x180" :href "/img/apple-touch-icon.png")
       (meta :name "apple-mobile-web-app-title" :content "skyizwhite")
       (link :rel "manifest" :href "/img/site.webmanifest")
       (link :rel "stylesheet" :href (bust-cache "/style/dist.css"))
       (link :rel "preconnect" :href "https://api.fonts.coollabs.io")
       (link :rel "stylesheet" :href "https://api.fonts.coollabs.io/css2?family=Noto+Sans+JP&display=swap")
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
  (set-response-header :content-type "text/html; charset=utf-8")
  (set-response-header :cache-control (if (string= (hp-env) "dev")
                                          "private, no-store, no-cache, must-revalidate"
                                          "public, max-age=60, s-maxage=300, stale-while-revalidate=300, stale-if-error=300"))
  (call-next-method app
                    (hsx:render-to-string
                     (match result
                       ((guard (or (list page metadata)
                                   page)
                               (typep page 'element))
                        (~document (complete-metadata metadata)
                          page))
                       (_ (error "Invalid response form"))))))
