(defpackage #:website/well-known/not-found
  (:use #:cl)
  (:export #:@not-found))
(in-package #:website/well-known/not-found)

(defun @not-found ()
  '(:|message| "Not found"))
