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

(defcomp ~article (&key title
                        content
                        published-at
                        draft-p)
  (hsx
   (<>
     (and draft-p
          (hsx
           (div :class (clsx "inline-flex items-center gap-2 px-3 py-1 mb-6 rounded-full"
                             "border border-accent-500/30 bg-accent-500/10"
                             "text-xs font-display font-semibold uppercase tracking-widest"
                             "text-accent-300")
             (span :class "size-1.5 rounded-full bg-accent-500 animate-pulse")
             "Draft Mode")))
     (article :class "prose max-w-none"
       (and published-at
            (hsx
             (div :class "not-prose mb-3 inline-flex items-center gap-1.5 text-xs text-subtle font-display tracking-wide"
               (span :class "uppercase opacity-70" "Published")
               (|time| :datetime (datetime published-at)
                       (jp-datetime published-at)))))
       (~title title)
       (raw! content)))))
