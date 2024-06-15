(uiop:define-package #:hp/components/layout
  (:use #:cl
        #:hsx)
  (:export #:layout))
(in-package #:hp/components/layout)

(defcomp layout (&key children)
  (hsx
   (body
     (header)
     (main
       children)
     (footer))))
