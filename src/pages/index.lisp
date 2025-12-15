(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:website/helper)
  (:export #:@get
           #:@head))
(in-package #:website/pages/index)


(defun @get (params)
  (declare (ignore params))
  (set-cache :sg)
  (hsx
   (<>
     (h1 "Hello World!"))))

; for health check
(defun @head (params)
  (declare (ignore params)))
