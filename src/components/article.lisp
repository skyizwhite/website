(defpackage #:website/components/article
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:import-from #:website/components/title
                #:~title)
  (:export #:~article))
(in-package #:website/components/article)

(defcomp ~draft-badge ()
  (hsx
   (div :class (clsx "mb-8 sm:mb-10 flex items-center gap-3"
                     "border-y border-base py-3")
     (span :class "size-1.5 rounded-full bg-invert animate-pulse")
     (span :class "eyebrow" "Draft Mode"))))

(defcomp ~article (&key title
                        content
                        published-at
                        draft-p)
  (hsx
   (<>
     (and draft-p (~draft-badge))
     (article :class "prose max-w-none"
       (~title
         :eyebrow (and published-at
                       (hsx
                        (span :class "inline-flex items-center gap-2"
                          "Published"
                          (|time| :datetime (datetime published-at)
                                  (jp-datetime published-at)))))
         title)
       (raw! content)))))
