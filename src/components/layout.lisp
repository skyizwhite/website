(defpackage #:website/components/layout
  (:use #:cl
        #:hsx)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/header
                #:~header)
  (:export #:~layout))
(in-package #:website/components/layout)

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))

(defcomp ~layout (&key metadata children)
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
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))
     (body
       :hx-ext "head-support, response-targets, preload"
       :hx-boost "true" :hx-target-404 "body" :hx-target-5* "body"
       :class (<> 
                "flex flex-col h-[100svh] w-full max-w-[700px] "
                "px-2 mx-auto")
       (~header)
       (div :class "flex flex-col flex-1 overflow-y-scroll"
         (main :class "flex-1 px-2 py-6 md:px-4 md:py-8"
           children)
         (footer :class "flex p-2 justify-center text-sm border-t-1"
           (p "© 2025 Akira Tempaku")))))))
