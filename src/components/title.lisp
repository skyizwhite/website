(defpackage #:website/components/title
  (:use #:cl
        #:hsx)
  (:export #:~title))
(in-package #:website/components/title)

(defcomp ~title (&key eyebrow children)
  (hsx
   (header :class "not-prose mb-8 sm:mb-16"
     (and eyebrow
          (hsx
           (div :class "flex items-center gap-4 mb-4 sm:mb-5"
             (span :class "eyebrow shrink-0" eyebrow)
             (span :class "flex-1 h-px bg-ink-200"))))
     (h1 :class "headline text-[clamp(2rem,6vw,3.25rem)]"
       children))))
