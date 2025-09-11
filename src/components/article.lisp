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
       (p :class "text-right text-sm text-gray-500"
         (and published-at
              (hsx
               (span
                 "Published: "
                 (|time| :datetime (datetime published-at)
                         (asctime published-at)))))
         (and published-at revised-at
              (hsx (br)))
         (and revised-at
              (hsx
               (span
                 "Last updated: "
                 (|time| :datetime (datetime revised-at)
                         (asctime revised-at))))))))))
