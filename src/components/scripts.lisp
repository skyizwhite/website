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
     (link :rel "stylesheet" :href (bust-cache "/assets/style/dist.css"))
     (link :rel "preconnect" :href "https://fonts.googleapis.com")
     (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
     (link
       :rel "preload"
       :as "style"
       :fetchpriority "high"
       :href *google-font-url*)
     (link
       :rel "stylesheet"
       :href *google-font-url*
       :media "print"
       :onload "this.media='all'")
     (noscript
       (link :rel "stylesheet" :href *google-font-url*))
     ;(script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
     (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))))
