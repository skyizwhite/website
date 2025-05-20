(defpackage #:website/components/scripts
  (:use #:cl
        #:hsx)
  (:export #:~scripts))
(in-package #:website/components/scripts)

(defparameter *google-font-url*
  "https://fonts.googleapis.com/css2?family=Zen+Maru+Gothic:wght@400;700&display=swap")

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))

(defcomp ~scripts ()
  (hsx
   (<>
     (link :rel "stylesheet" :href (bust-cache "/style/dist.css"))
     (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
     (link :rel "preconnect" :href "https://fonts.googleapis.com")
     (link
       :rel "preload"
       :href *google-font-url*
       :as "style"
       :onload "this.onload=null;this.rel='stylesheet'")
     (noscript
       (link :rel "stylesheet" :href *google-font-url*))
     (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
     (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-preload@2.1.1/dist/preload.min.js")
     (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-head-support@2.0.4/dist/head-support.min.js")
     (script :src "https://cdn.jsdelivr.net/npm/htmx-ext-response-targets@2.0.3/dist/response-targets.min.js")
     (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))))
