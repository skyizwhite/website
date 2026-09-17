(defpackage #:website/components/footer
  (:use #:cl
        #:hsx)
  (:export #:~footer))
(in-package #:website/components/footer)

(defcomp ~footer ()
  (hsx
   (footer :class "mt-auto border-t border-base"
     (div :class "shell py-7 sm:py-10 flex items-baseline justify-between gap-6"
       (span :class "text-sm font-extrabold tracking-tight text-fg"
         "skyizwhite")
       (p :class "eyebrow"
         "© 2025 Akira Tempaku")))))
