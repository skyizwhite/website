(defpackage #:hp/components/layout
  (:use #:cl
        #:hsx)
  (:export #:layout))
(in-package #:hp/components/layout)

(defcomp layout (&key children)
  (hsx
   (body :hx-ext "head-support"
     (main :class "uk-container"
       children))))
