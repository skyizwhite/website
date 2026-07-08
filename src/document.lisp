(defpackage #:website/document
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/header
                #:~header)
  (:import-from #:website/helper
                #:asset-path)
  (:export #:~document))
(in-package #:website/document)

(defcomp ~document (&key children)
  (hsx
   (html :lang "ja"
     (head
       (link :rel "stylesheet" :href (asset-path "style/dist.css"))
       (script :src (asset-path "js/nomini.min.js") :defer t)
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
