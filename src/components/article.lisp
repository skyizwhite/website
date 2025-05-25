(defpackage #:website/components/article
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/time
                #:datetime
                #:asctime)
  (:export #:~article))
(in-package #:website/components/article)

(defcomp ~article (&key title
                        content
                        published-at
                        revised-at
                        draft-p)
  (hsx
   (<>
     (and draft-p (hsx (p :class "text-lg text-pink-500" "Draft Mode")))
     (article :class "prose max-w-none"
       (h1 title)
       (raw! content)
       (p :class "text-right"
         (and published-at
              (hsx
               (span
                 "(Published: "
                 (|time| :datetime (datetime published-at)
                         (asctime published-at))
                 ")")))
         (and revised-at
              (hsx
               (<>
                 (br)
                 (span
                   "(Last updated: "
                   (|time| :datetime (datetime revised-at)
                           (asctime revised-at))
                   ")")))))))))
