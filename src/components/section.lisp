(defpackage #:website/components/section
  (:use #:cl
        #:hsx)
  (:export #:~section))
(in-package #:website/components/section)

(defcomp ~section (&key heading aside children)
  (hsx
   (section :class "mt-14 sm:mt-24"
     (header :class "flex items-baseline gap-4 mb-4 sm:mb-5"
       (h2 :class "headline text-xl sm:text-2xl shrink-0"
         heading)
       (span :class "flex-1 h-px bg-ink-200"))
     children
     (and aside
          (hsx
           (div :class "mt-6 sm:mt-8 flex justify-end"
             aside))))))
