(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx)
  (:local-nicknames (#:jg #:jingle))
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "お探しのページは見つかりませんでした。"))

(defcomp page ()
  (hsx
   (h1 :class "text-red-600"
     "404 Not Found")))

(defun handle-not-found ()
  (jg:set-response-status :not-found)
  (list (page) *metadata*))
