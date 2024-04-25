(defpackage #:hp/routes/not-found
  (:use #:cl
        #:piccolo)
  (:local-nicknames (#:view #:hp/view/*))
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "お探しのページは見つかりませんでした。"))

(define-element page ()
  (section
    (h1 "404 Not Found")))

(defun handle-not-found ()
  (view:render (page)
               :status :not-found
               :metadata *metadata*))
