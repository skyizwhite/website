(defpackage #:website/api/not-found
  (:use #:cl
        #:jingle)
  (:export #:handle-not-found))
(in-package #:website/api/not-found)

(defun handle-not-found ()
  (set-response-status :not-found)
  '(:|message| "Not found"))
