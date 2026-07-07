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

(defparameter *preload-fonts*
  '("baloo-2-v23-latin-regular.woff2"
    "baloo-2-v23-latin-600.woff2"
    "baloo-2-v23-latin-700.woff2"
    "noto-sans-jp-v56-japanese_latin-regular.woff2"
    "noto-sans-jp-v56-japanese_latin-500.woff2"
    "noto-sans-jp-v56-japanese_latin-600.woff2"
    "noto-sans-jp-v56-japanese_latin-700.woff2"
    "noto-sans-jp-v56-japanese_latin-800.woff2"
    "noto-sans-jp-v56-japanese_latin-900.woff2"))

(defcomp ~document (&key children)
  (hsx
   (html :lang "ja"
     (head
       (loop
         :for font :in *preload-fonts* :collect
            (hsx
             (link :rel "preload" :as "font" :type "font/woff2" :crossorigin t
               :href (format nil "/assets/fonts/~a" font))))
       (link :rel "stylesheet" :href (bust-cache "/assets/style/dist.css"))
       (script :src (bust-cache "/assets/js/nomini.min.js") :defer t)
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
