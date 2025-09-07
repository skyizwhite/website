(defpackage #:website/components/scripts
  (:use #:cl
        #:hsx)
  (:export #:~scripts))
(in-package #:website/components/scripts)

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))

(defcomp ~scripts ()
  (hsx
   (<>
     (link :rel "preconnect" :href "https://fonts.googleapis.com")
     (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
     (link
       :rel "stylesheet"
       :href "https://fonts.googleapis.com/css2?family=Baloo+2:wght@400;600&display=swap")
     (link :rel "stylesheet" :href (bust-cache "/assets/style/dist.css"))
     ;(script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
     (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))))
