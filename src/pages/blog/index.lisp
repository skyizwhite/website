(defpackage #:website/pages/blog/index
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-blog-list)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:import-from #:website/components/title
                #:~title)
  (:export #:@get))
(in-package #:website/pages/blog/index)

(defparameter *metadata*
  (list :title "blog"))

(defun @get (params)
  (declare (ignore params))
  (with-cms-fallback ((404 (error-page 404))
                      (t (error-page 500)))
    (set-cache :isr)
    (set-metadata *metadata*)
    (let ((blogs (fetch-blog-list :page 1)))
      (hsx
       (section
         (~title "Blog")
         (ul :class "flex flex-col gap-2"
           (loop
             :for item :in blogs :collect
                (let ((published-at (getf item :published-at)))
                  (hsx
                   (li
                     (a
                       :href (format nil "/blog/~a" (getf item :id))
                       :class (clsx "group block p-4 sm:p-5 rounded-2xl"
                                    "border border-base surface"
                                    "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                                    "transition-all duration-200")
                       (div :class "sm:flex items-baseline justify-between gap-4"
                         (h2 :class "font-display font-semibold text-base sm:text-lg text-fg group-hover:accent-text"
                           (getf item :title))
                         (and published-at
                              (hsx
                               (|time|
                                :datetime (datetime published-at)
                                :class "shrink-0 text-xs text-subtle font-display tracking-wide"
                                (jp-datetime published-at)))))))))))
         ;TODO: pagenation
         )))))
