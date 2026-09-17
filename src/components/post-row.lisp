(defpackage #:website/components/post-row
  (:use #:cl
        #:hsx
        #:website/components/icons)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:~post-row))
(in-package #:website/components/post-row)

(defcomp ~post-row (&key id title published-at)
  (hsx
   (li
     (a
       :href (format nil "/blog/~a" id)
       :class (clsx "group row flex-wrap items-baseline gap-x-5 gap-y-2 sm:gap-x-8"
                    "text-fg hover:text-subtle")
       (and published-at
            (hsx
             (|time|
              :datetime (datetime published-at)
              :class "eyebrow order-3 sm:order-1 shrink-0 w-full sm:w-44 whitespace-nowrap"
              (jp-datetime published-at))))
       (span :class "row-label order-1 sm:order-2 flex-1 min-w-0"
         title)
       (~icon-arrow-right
         :class (clsx "icon-frame order-2 sm:order-3 size-4 self-center"
                      "transition-transform group-hover:translate-x-1"))
       (span :class "row-mark group-hover:w-full")))))
