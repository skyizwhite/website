(defpackage #:hp/routes/index
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(defcomp page ()
  (hsx
   (section :class "h-[100svh] bg-[url('/fv.jpg')] bg-cover bg-center flex items-end pb-12"
     (div :class "container flex justify-between items-end"
       (h1 :class "flex flex-col text-6xl font-bold italic leading-normal"
         (span :class "block"
           "Bridging Minds,")
         (span :class "block"
           "Building Futures."))
       (p "© 2025 skyizwhite")))))

(defun handle-get (params)
  (declare (ignore params))
  (page))
