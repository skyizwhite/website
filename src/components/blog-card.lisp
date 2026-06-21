(defpackage #:website/components/blog-card
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:~blog-card))
(in-package #:website/components/blog-card)

(defcomp ~blog-card (&key id title published-at)
  (hsx
   (li
     (a
       :href (format nil "/blog/~a" id)
       :class (clsx "group block p-4 sm:p-5 rounded-2xl"
                    "border border-base surface"
                    "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                    "transition-all duration-200")
       (div :class "sm:flex items-baseline justify-between gap-4"
         (h2 :class "font-display font-semibold text-base sm:text-lg text-fg group-hover:accent-text"
           title)
         (and published-at
              (hsx
               (|time|
                :datetime (datetime published-at)
                :class "shrink-0 text-xs text-subtle font-display tracking-wide"
                (jp-datetime published-at)))))))))
