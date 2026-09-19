(defpackage #:website/document
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:import-from #:website/components/header
                #:~header)
  (:import-from #:website/components/footer
                #:~footer)
  (:import-from #:website/helper
                #:asset-path
                #:*fonts-css*
                #:*preload-fonts*)
  (:export #:~document))
(in-package #:website/document)

(defcomp ~document (&key children)
  (hsx
   (html :lang "ja"
     (head
       (loop
         :for font :in *preload-fonts* :collect
            (hsx (link :rel "preload" :as "font" :type "font/woff2" :crossorigin t
                       :href (asset-path font :bust nil))))
       (link :rel "stylesheet" :href (asset-path "style/dist.css"))
       (and *fonts-css*
            (hsx (link :rel "stylesheet" :href (asset-path *fonts-css* :bust nil))))
       (script :src (asset-path "js/nomini.min.js") :defer t)
       (~metadata))
     (body :class (clsx "min-h-[100svh] flex flex-col antialiased bg-base text-fg"
                        "selection:bg-ink-900 selection:text-invert")
       (~header)
       (main :class "flex-1"
         (div :class "shell pt-8 pb-16 sm:pt-20 sm:pb-32"
           children))
       (~footer)))))
