(defpackage #:hp/components/header
  (:use #:cl
        #:hsx)
  (:export #:page-header))
(in-package #:hp/components/header)

(defcomp page-header ()
  (let ((links '(("Home" "/")
                 ("About" "/about")
                 ("Work" "/work")
                 ("Blog" "/blog")
                 ("Contact" "/contact"))))
    (hsx
     (header :class "fixed top-0 w-full"
       (div :class "container flex justify-between py-6"
         (h1
           (a :href "/"
             (img
               :src "/logo.png" :alt "Amongtellers"
               :class "w-52 h-auto")))
         (ul :class "flex flex-col gap-4"
           (loop
             :for (content href) :in links :collect
                (li :class "flex items-center"
                  (a :href href :class "text-xl font-bold pl-6 hover:text-orange-600"
                    content)))))))))
