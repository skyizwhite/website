(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx)
  (:local-nicknames (#:jg #:jingle))
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "お探しのページは削除されたか、URLが間違っている可能性があります。"))

(defcomp page ()
  (hsx
   (div :class "flex flex-col justify-center items-center h-full gap-4"
     (h1 :class "text-2xl text-red-600"
       "404 Not Found")
     (p (getf *metadata* :description))
     (a :href "/" :class "text-pink-600"
       "トップページに戻る"))))

(defun handle-not-found ()
  (jg:set-response-status :not-found)
  (list (page) *metadata*))
