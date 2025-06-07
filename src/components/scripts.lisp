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
     (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
     (link :rel "preconnect" :href "https://fonts.googleapis.com")
     (link
       :rel "preload"
       :href *google-font-url*
       :as "style"
       :onload "this.onload=null;this.rel='stylesheet'")
     (noscript
       (link :rel "stylesheet" :href *google-font-url*))
     (script :type "module" :src "https://cdn.jsdelivr.net/gh/starfederation/datastar@v1.0.0-beta.11/bundles/datastar.js"))))
