(uiop:define-package #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:export #:on-get))
(in-package #:hp/routes/index)

;;; View

(pi:define-element page ()
  (pi:h
    (cmp:layout
      (section :class "h-full flex justify-center items-center"
        (div :class "flex flex-col items-center gap-2"
          (div :class "avatar"
            (div :class "w-32 mask mask-squircle"
              (img :src "/public/img/me.jpg")))
          (p :class "text-primary text-3xl text-center"
            "Hello, World!"))))))

;;; Controller

(defun on-get (params)
  (declare (ignore params))
  (jg:with-html-response
    (pi:element-string (page))))
