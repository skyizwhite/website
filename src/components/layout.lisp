(defpackage #:hp/components/layout
  (:use #:cl
        #:hsx)
  (:import-from #:hp/lib/metadata
                #:~metadata)
  (:import-from #:jingle
                #:request-uri)
  (:export #:~layout))
(in-package #:hp/components/layout)

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))

(defparameter *nav-menu*
  '(("/bio" "bio")
    ("/work" "work")
    ("/blog" "blog")))

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
       (link :rel "stylesheet" :href "https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic&display=swap")
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-preload@2.1.1/dist/preload.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-head-support@2.0.4/dist/head-support.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-response-targets@2.0.3/dist/response-targets.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))
     (body
       :hx-ext "head-support, response-targets, preload"
       :hx-boost "true" :hx-target-404 "body" :hx-target-5* "body"
       :class (<> 
                "bg-amber-50/90 flex flex-col h-[100svh] w-full max-w-[700px] "
                "px-2 pt-2 mx-auto md:px-8 md:pt-8")
       (header :class "flex justify-between pb-2 md:pb-4 border-b-1"            
         (h1 :class "text-2xl md:text-3xl font-bold"
           (a :href "/"
             "skyizwhite"))
         (nav :class "flex items-end"
           (ul
             :preload "mouseover"
             :class "flex gap-4 text-lg"
             (loop
               :for (href label) :in *nav-menu*
               :collect
                  (if (search href (request-uri jingle:*request*))
                      (hsx (li :class "text-pink-500"
                             label))
                      (hsx (li (a :href href :class "underline hover:text-pink-500"
                                 label))))))))
       (main :class "flex-1 pt-2 pb-4 md:pt-4 md:pb-8 overflow-y-scroll "
         children)))))
