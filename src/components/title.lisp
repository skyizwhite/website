(defpackage #:website/components/title
  (:use #:cl
        #:hsx)
  (:export #:~title))
(in-package #:website/components/title)

(defcomp ~title (&key children)
  (hsx
   (h1 :class "not-prose mb-10 pb-6 border-b border-base font-display font-bold text-3xl sm:text-4xl tracking-tight text-fg"
     children)))
