(defpackage #:website/components/article
  (:use #:cl
        #:hsx)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:~article))
(in-package #:website/components/article)

(defcomp ~article (&key title content revised-at draft-p)
  (hsx
   (<>
     (and draft-p (hsx (p :class "text-lg text-pink-500" "下書きモード")))
     (article :class "prose max-w-none"
       (h1 title)
       (raw! content)
       (p :class "text-right"
         "（最終更新："
         (|time| :datetime (datetime revised-at)
                 (jp-datetime revised-at))
         "）")))))
