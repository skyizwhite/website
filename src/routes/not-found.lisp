(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx
        #:hp/response)
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "お探しのページは見つかりませんでした。"))

(defcomp page ()
  (hsx
   (h1 "404 Not Found")))

(defun handle-not-found ()
  (response (page)
            :status :not-found
            :metadata *metadata*))
