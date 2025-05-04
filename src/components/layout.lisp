(defpackage #:website/components/layout
  (:use #:cl
        #:hsx)
  (:import-from #:website/components/header
                #:~header)
  (:export #:~layout))
(in-package #:website/components/layout)

(defcomp ~layout (&key children)
  (hsx
   (div :class "flex flex-col h-[100svh] w-full max-w-[700px] px-2 mx-auto"
     (~header)
     (div :class "flex flex-col flex-1 overflow-y-scroll"
       (main :class "flex-1 px-2 py-6 md:px-4 md:py-8"
         children)
       (footer :class "flex p-2 justify-center text-sm border-t-1"
         (p "© 2025 Akira Tempaku"))))))
