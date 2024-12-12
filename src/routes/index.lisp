(defpackage #:hp/routes/index
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(defcomp ~page ()
  (hsx
   (section
     ; first view
     (div :class "h-[100svh] bg-[url('/fv.jpg')] bg-cover bg-center flex"
       (div :class "container flex items-end justify-between"
         (h1 :class "flex flex-col text-6xl font-bold italic leading-normal pb-10"
           (span :class "block"
             "Beyond Differences,")
           (span :class "block"
             "Shaping Tomorrow")))))))

(defun handle-get (params)
  (declare (ignore params))
  (~page))
