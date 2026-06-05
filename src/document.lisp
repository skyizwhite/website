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
  "https://fonts.googleapis.com/css2?family=Baloo+2:wght@400;600;700&family=Noto+Sans+JP:wght@400;500;600;700&display=swap")

(defcomp ~document (&key children)
  (hsx
   (html :lang "ja"
     (head
       (link :rel "preconnect" :href "https://fonts.googleapis.com")
       (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
       (link :rel "preload" :as "style" :fetchpriority "high" :href *google-fonts-url*)
       (link :rel "stylesheet" :href *google-fonts-url* :media "print" :onload "this.media='all'")
       (link :rel "stylesheet" :href (bust-cache "/assets/style/dist.css"))
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.10/dist/htmx.min.js")
       (script :src "https://cdn.jsdelivr.net/npm/alpinejs@3.14.9/dist/cdn.min.js" :defer t)
       (~metadata))
     (body :class (clsx "min-h-[100svh] flex flex-col antialiased text-fg"
                        "selection:bg-accent-500/20 selection:text-fg")
       (~header)
       (div :class "w-full max-w-[760px] mx-auto px-4 sm:px-6 flex-1 flex flex-col"
         (main :class "flex-1 py-10 sm:py-14"
           children)
         (footer :class "mt-auto py-8 text-center text-xs text-subtle border-t border-base"
           (p :class "font-display tracking-wide"
             "© 2025 Akira Tempaku")))))))

(defun bust-cache (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))
