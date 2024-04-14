(defpackage #:hp/routes/not-found
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view/*))
  (:export #:handle-not-found))
(in-package #:hp/routes/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "お探しのページは見つかりませんでした。"))

(pi:define-element page ()
  (pi:h
    (section
      (h1 "404 Not Found"))))

(defun handle-not-found ()
  (view:render (page)
               :status :not-found
               :metadata *metadata*))
