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
     (and draft-p (hsx (p :class "text-lg text-pink-500" "Draft Mode")))
     (article :class "prose max-w-none"
       (h1 title)
       (p :class "text-right text-sm text-gray-500"
         (and published-at
              (hsx
               (span
                 "公開日時："
                 (|time| :datetime (datetime published-at)
                         (jp-datetime published-at)))))
         (and published-at revised-at
              (hsx (br)))
         (and revised-at
              (hsx
               (span
                 "更新日時："
                 (|time| :datetime (datetime revised-at)
                         (jp-datetime revised-at))))))
       (raw! content)))))
