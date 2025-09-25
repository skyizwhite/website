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

(defcomp ~document (&key children)
  (hsx
   (html :lang "en"
     (head
       (~metadata)
       (link :rel "preconnect" :href "https://fonts.googleapis.com")
       (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
       (link
         :rel "stylesheet"
         :href "https://fonts.googleapis.com/css2?family=Baloo+2:wght@400;600&display=swap")
       (link :rel "stylesheet" :href (bust-cache "/assets/style/dist.css"))
       ;(script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.4/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t))
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
