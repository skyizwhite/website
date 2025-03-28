(defpackage #:hp/routes/not-found
  (:use #:cl
        #:hsx)
  (:import-from :jingle)
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."))

(defcomp ~page ()
  (hsx
   (section
     (h1 "404 Not Found"))))

(defun handle-not-found ()
  (jingle:set-response-status :not-found)
  (list (~page) *metadata*))
