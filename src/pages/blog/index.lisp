(defpackage #:website/pages/blog/index
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-blog-list)
  (:import-from #:website/components/title
                #:~title)
  (:import-from #:website/components/post-row
                #:~post-row)
  (:export #:@get))
(in-package #:website/pages/blog/index)

(defparameter *metadata*
  (list :title "blog"))

(defun @get (params)
  (declare (ignore params))
  (with-cms-fallback ((404 (error-page 404))
                      (t (error-page 500)))
    (set-cache :swr)
    (set-metadata *metadata*)
    (let ((blogs (fetch-blog-list :page 1)))
      (hsx
       (section
         (~title "Blog")
         (ul
           (loop
             :for item :in blogs :collect
                (~post-row :id (getf item :id)
                           :title (getf item :title)
                           :published-at (getf item :published-at))))
         ;TODO: pagenation
         )))))
