(defpackage #:website/components/header
  (:use #:cl
        #:hsx)
  (:import-from #:jingle
                #:request-uri)
  (:export #:~header))
(in-package #:website/components/header)

(defparameter *nav-menu*
  '(("/bio" "bio")
    ("/work" "work")
    ("/blog" "blog")))

(defcomp ~header ()
  (hsx
   (header :class "flex justify-between py-2 md:py-4 border-b-1 sticky top-0 bg-white"
     (h1 :class "text-2xl md:text-3xl font-bold"
       (a :href "/"
         "skyizwhite"))
     (nav :class "flex items-end"
       (ul :preload "mouseover" :class "flex gap-4 text-xl"
         (loop
           :for (href label) :in *nav-menu* :collect
              (if (search href (request-uri jingle:*request*))
                  (hsx (li :class "text-pink-500"
                         label))
                  (hsx (li (a :href href :class "hover:text-pink-500"
                             label))))))))))
