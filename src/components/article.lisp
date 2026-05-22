(defpackage #:website/components/article
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:~article))
(in-package #:website/components/article)

(defcomp ~article (&key title
                        content
                        published-at
                        revised-at
                        draft-p)
  (hsx
   (<>
     (and draft-p
          (hsx
           (div :class (clsx "inline-flex items-center gap-2 px-3 py-1 mb-6 rounded-full"
                             "border border-accent-500/30 bg-accent-500/10"
                             "text-xs font-display font-semibold uppercase tracking-widest"
                             "text-accent-600 dark:text-accent-300")
             (span :class "size-1.5 rounded-full bg-accent-500 animate-pulse")
             "Draft Mode")))
     (article :class "prose max-w-none"
       (header :class "not-prose mb-10 pb-6 border-b border-token"
         (h1 :class "font-display font-bold text-3xl sm:text-4xl tracking-tight text-fg"
           title)
         (div :class "mt-4 flex flex-wrap items-center gap-x-4 gap-y-1 text-xs text-subtle font-display tracking-wide"
           (and published-at
                (hsx
                 (span :class "inline-flex items-center gap-1.5"
                   (span :class "uppercase opacity-70" "Published")
                   (|time| :datetime (datetime published-at)
                           (jp-datetime published-at)))))
           (and revised-at
                (hsx
                 (span :class "inline-flex items-center gap-1.5"
                   (span :class "uppercase opacity-70" "Updated")
                   (|time| :datetime (datetime revised-at)
                           (jp-datetime revised-at)))))))
       (raw! content)))))
