(uiop:define-package #:hp/routes/user/=name
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:export #:on-get))
(in-package #:hp/routes/user/=name)

;;; View

(pi:define-element page (name)
  (pi:h
    (cmp:layout
      (section :class "h-full flex justify-center items-center"
        (p :class "text-primary text-4xl"
          "Hello, " name "!")))))

;;; Controller

(defun on-get (params)
  (jg:with-html-response
    (jg:with-request-params ((name :name)) params
      (pi:element-string (page :name name)))))
