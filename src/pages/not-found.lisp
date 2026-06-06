(defpackage #:website/pages/not-found
  (:use #:cl
        #:website/helper)
  (:export #:@not-found))
(in-package #:website/pages/not-found)

;; ningle-fbr wires the /not-found route to this exported @NOT-FOUND symbol,
;; so it must stay; the actual rendering lives in ERROR-PAGE.
(defun @not-found ()
  (error-page 404))
