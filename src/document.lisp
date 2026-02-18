(defpackage #:website/document
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/header
                #:~header)
  (:export #:~document))
(in-package #:website/document)

(defparameter *google-fonts-url*
  "https://fonts.googleapis.com/css2?family=Baloo+2:wght@400;600&family=Noto+Sans+JP:wght@400;600&display=swap")

(defcomp ~document (&key children)
  (hsx
   (html :lang "ja"
     (head
       (link :rel "preconnect" :href "https://fonts.googleapis.com")
       (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
       (link :rel "preload" :as "style" :fetchpriority "high" :href *google-fonts-url*)
       (link :rel "stylesheet" :href *google-fonts-url* :media "print" :onload "this.media='all'")
       (link :rel "stylesheet" :href (bust-cache "/assets/style/dist.css"))
       ;(script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t)
       (~metadata))
     (body
       (div :class "flex flex-col h-[100svh] w-full max-w-[700px] px-2 mx-auto"
         (~header)
         (div :class "flex flex-col flex-1 overflow-y-scroll"
           (main :class "flex-1 px-2 py-6 md:px-4 md:py-8"
             children)
           (footer :class "flex p-2 justify-center text-sm border-t-1"
             (p "© 2025 Akira Tempaku"))))))))

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))
