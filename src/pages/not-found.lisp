(defpackage #:website/pages/not-found
  (:use #:cl
        #:website/helper)
  (:export #:@not-found))
(in-package #:website/pages/not-found)

(defun @not-found ()
  (error-page 404))
