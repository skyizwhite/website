(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx)
  (:import-from #:jingle
                #:set-response-status)
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."))

(defcomp ~page ()
  (hsx
   (section :class "flex flex-col h-full items-center justify-center gap-y-6"
     (h1 :class "font-bold text-2xl"
       "404 Not Found")
     (a :href "/" :class "text-lg text-pink-500 hover:underline"
       "Back to TOP"))))

(defun handle-not-found ()
  (set-response-status :not-found)
  (list (~page) *metadata*))
