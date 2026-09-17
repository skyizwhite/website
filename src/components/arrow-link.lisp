(defpackage #:website/components/arrow-link
  (:use #:cl
        #:hsx
        #:website/components/icons)
  (:export #:~arrow-link))
(in-package #:website/components/arrow-link)

(defcomp ~arrow-link (&key href (direction :forward) children)
  (let ((back (eq direction :back)))
    (hsx
     (a :href href :class "group text-link"
       (and back
            (hsx
             (~icon-arrow-left
               :class "size-3.5 transition-transform group-hover:-translate-x-1")))
       children
       (and (not back)
            (hsx
             (~icon-arrow-right
               :class "size-3.5 transition-transform group-hover:translate-x-1")))))))
