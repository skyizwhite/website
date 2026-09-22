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
                        published-at)
  (hsx
   (article :class "prose max-w-none"
     (~title
       :eyebrow (and published-at
                     (hsx
                      (span :class "inline-flex items-center gap-2"
                        "Published"
                        (|time| :datetime (datetime published-at)
                                (jp-datetime published-at)))))
       title)
     (raw! content))))
