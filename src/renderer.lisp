(defpackage #:website/renderer
  (:use #:cl
        #:hsx
        #:trivia)
  (:import-from #:jingle
                #:get-request-header
                #:set-response-header)
  (:import-from #:hsx/element
                #:element)
  (:import-from #:website/lib/env
                #:website-url
                #:website-env)
  (:import-from #:website/components/layout
                #:~layout)
  (:import-from #:website/components/metadata
                #:~metadata))
(in-package #:website/renderer)

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))

(defcomp ~document (&key metadata children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (meta :name "viewport" :content "width=device-width, initial-scale=1")
       (~metadata :metadata metadata)
       (link :rel "icon" :type "image/png" :href "/img/favicon-96x96.png" :sizes "96x96")
       (link :rel "icon" :type "image/svg+xml" :href "/img/favicon.svg")
       (link :rel "shortcut icon" :href "/img/favicon.ico")
       (link :rel "apple-touch-icon" :sizes "180x180" :href "/img/apple-touch-icon.png")
       (meta :name "apple-mobile-web-app-title" :content "skyizwhite")
       (link :rel "manifest" :href "/img/site.webmanifest")
       (link :rel "stylesheet" :href (bust-cache "/style/dist.css"))
       (link :rel "preconnect" :href "https://fonts.googleapis.com")
       (link :rel "stylesheet" :href "https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;500;700&display=swap")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-preload@2.1.1/dist/preload.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-head-support@2.0.4/dist/head-support.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-response-targets@2.0.3/dist/response-targets.min.js")
       ;(script :src "https://cdn.jsdelivr.net/npm/htmx-ext-alpine-morph@2.0.1/alpine-morph.min.js")
       ;(script :src "https://cdn.jsdelivr.net/npm/@alpinejs/morph@3.14.9/dist/cdn.min.js" :defer t)
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))
     children)))

(defmethod jingle:process-response ((app jingle:app) result)
  (set-response-header :content-type "text/html; charset=utf-8")
  (set-response-header :cache-control (if (string= (website-env) "dev")
                                          "private, no-store"
                                          "public, max-age=60"))
  (match result
    ((guard (or (list body metadata)
                body)
            (typep body 'element))
     (call-next-method app
                       (hsx:render-to-string
                        (~document :metadata metadata
                          (~layout
                            body)))))
    (_ (error "Invalid response form"))))
