(defpackage #:website/routes/not-found
  (:use #:cl
        #:hsx
        #:jingle)
  (:export #:handle-not-found))
(in-package #:website/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."
    :error t))

(defcomp ~page ()
  (hsx
   (div :class "flex flex-col h-full items-center justify-center gap-y-6"
     (h1 :class "font-bold text-2xl"
       "404 Not Found")
     (a :href "/" :class "text-lg text-pink-500 hover:underline"
       "Back to TOP"))))

(defun handle-not-found ()
  (setf (context :metadata) *metadata*)
  (~page))
