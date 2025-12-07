(defpackage #:website/api/not-found
  (:use #:cl
        #:jingle)
  (:export #:@not-found))
(in-package #:website/api/not-found)

(defun @not-found ()
  (set-response-status :not-found)
  '(:|message| "Not found"))
