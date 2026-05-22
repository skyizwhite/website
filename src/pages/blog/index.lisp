(defpackage #:website/pages/blog/index
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:fetch-blog-list)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:@get))
(in-package #:website/pages/blog/index)

(defparameter *metadata*
  (list :title "blog"))

(defun @get (params)
  (declare (ignore params))
  (set-cache :isr)
  (set-metadata *metadata*)
  (let ((blogs (fetch-blog-list :page 1)))
    (hsx
     (section
       (header :class "mb-10 pb-6 border-b border-base"
         (h1 :class "font-display font-bold text-3xl sm:text-4xl tracking-tight"
           "Blog"))
       (ul :class "flex flex-col gap-2"
         (loop
           :for item :in blogs :collect
              (hsx
               (li
                 (a
                   :href (format nil "/blog/~a" (getf item :id))
                   :class (clsx "group block p-4 sm:p-5 rounded-2xl"
                                "border border-base surface"
                                "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                                "transition-all duration-200")
                   (div :class "sm:flex items-baseline justify-between gap-4"
                     (h2 :class "font-display font-semibold text-base sm:text-lg text-fg group-hover:accent-text transition-all"
                       (getf item :title))
                     (and (getf item :published-at)
                          (hsx
                           (|time|
                            :datetime (datetime (getf item :published-at))
                            :class "shrink-0 text-xs text-subtle font-display tracking-wide"
                            (jp-datetime (getf item :published-at)))))))))))
       ;TODO: pagenation
       ))))
