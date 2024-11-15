(defpackage #:hp/routes/index
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(defcomp page ()
  (hsx
   (<>
     (h1 :class "text-green-600"
       "こんにちは")
     (div :x-data "{
         open: false,
         get isOpen() { return this.open },
         toggle() { this.open = ! this.open },
       }"
       (button :@click "toggle()"
         "Toggle")
       (div :x-show "isOpen"
         "Content ...")))))

(defun handle-get (params)
  (declare (ignore params))
  (page))
