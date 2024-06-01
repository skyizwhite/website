(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx)
  (:import-from #:hp/view/responser
                #:response)
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "お探しのページは見つかりませんでした。"))

(defcomp page ()
  (hsx
   (div :class "h-full place-content-center"
     (h1
       :class "text-rose-400 text-4xl text-center"
       "404 Not Found"))))

(defun handle-not-found ()
  (response (page)
            :status :not-found
            :metadata *metadata*))
