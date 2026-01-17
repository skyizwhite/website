(defpackage #:website/pages/not-found
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:export #:@not-found))
(in-package #:website/pages/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."
    :error t))

(defun @not-found ()
  (set-cache :ssr)
  (set-response-status :not-found)
  (set-metadata *metadata*)
  (hsx
   (div :class "flex flex-col h-full items-center justify-center gap-y-6"
     (h1 :class "font-bold text-2xl"
       "404 Not Found")
     (a :href "/" :class "text-lg text-pink-500 hover:underline"
       "Back to TOP"))))
