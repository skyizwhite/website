(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx)
  (:local-nicknames (#:jg #:jingle))
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."))

(defcomp page ()
  (hsx
   (section :class "container flex flex-col justify-center items-center h-full gap-4"
     (h1 :class "text-2xl text-red-600"
       (getf *metadata* :title))
     (p (getf *metadata* :description))
     (a :href "/" :class "text-orange-600"
       "Return to the homepage"))))

(defun handle-not-found ()
  (jg:set-response-status :not-found)
  (list (page) *metadata*))
