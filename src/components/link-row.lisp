(defpackage #:website/components/link-row
  (:use #:cl
        #:hsx
        #:website/components/icons)
  (:export #:~link-row))
(in-package #:website/components/link-row)

(defcomp ~link-row (&key label href icon external)
  (hsx
   (li
     (a
       :href href
       :target (and external "_blank")
       :rel (and external "me noopener")
       :class "group row h-full items-center gap-4 text-fg hover:text-subtle"
       (span :class "icon-frame size-5"
         icon)
       (span :class "row-label flex-1 min-w-0"
         label)
       (if external
           (hsx
            (~icon-external-link
              :class "icon-frame size-4 transition-transform group-hover:-translate-y-0.5"))
           (hsx
            (~icon-arrow-right
              :class "icon-frame size-4 transition-transform group-hover:translate-x-1")))
       (span :class "row-mark group-hover:w-full")))))
