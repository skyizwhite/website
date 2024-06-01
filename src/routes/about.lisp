(defpackage #:hp/routes/about
  (:use #:cl
        #:hsx)
  (:import-from #:hp/view/*
                #:response)
  (:export #:handle-get))
(in-package #:hp/routes/about)

(defcomp page ()
  (hsx
   (div :class "h-full place-content-center"
     (h1
       :class "text-4xl text-center"
       "Coming soon..."))))

(defun handle-get (params)
  (declare (ignore params))
  (response (page)))
