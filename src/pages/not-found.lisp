(defpackage #:website/pages/not-found
  (:use #:cl
        #:hsx
        #:website/helper)
  (:export #:@not-found))
(in-package #:website/pages/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."
    :error t))

(defun @not-found ()
  (set-metadata *metadata*)
  (hsx
   (h1 "404 Not Found")))
