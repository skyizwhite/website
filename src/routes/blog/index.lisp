(defpackage #:website/routes/blog/index
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:get-blog-list)
  (:import-from #:website/lib/time
                #:asctime)
  (:export #:handle-get))
(in-package #:website/routes/blog/index)

(defparameter *metadata*
  (list :title "blog"))

(defun handle-get (params)
  (declare (ignore params))
  (setf (context :metadata) *metadata*)
  (let ((blogs (getf (get-blog-list :query '(:fields "id,title,publishedAt"
                                             :limit 100))
                     :contents)))
    (hsx
     (section
       (h1 :class "font-bold text-4xl mb-8"
         "Blog")
       (ul :preload "mouseover" :class "flex flex-col gap-y-2"
         (loop
           :for item :in blogs :collect
              (hsx
               (li
                 (a
                   :class "hover:text-pink-500"
                   :href (format nil "/blog/~a" (getf item :id))
                   (span :class "font-bold"
                     "･ " (getf item :title))
                   (span :class "text-sm text-gray-400 ml-2"
                     "(" (asctime (getf item :published-at)) ")"))))))
       ;TODO: pagenation
       ))))
