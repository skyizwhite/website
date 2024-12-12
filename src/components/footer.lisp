(defpackage #:hp/components/footer
  (:use #:cl
       #:hsx)
  (:export #:~footer))
(in-package #:hp/components/footer)

(defcomp ~footer ()
  (hsx
   (footer :class "fixed bottom-0 w-full"
     (div :class "container py-6 flex justify-end"
       (p "© 2025 skyizwhite")))))