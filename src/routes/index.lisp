(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:ui #:hp/ui/*))
  (:local-nicknames (#:utils #:hp/utils/*))
  (:export #:*index-app*))
(in-package #:hp/routes/index)

;;; View

(pi:define-element counter (value)
  (pi:h
    (div :id "counter" :class "h-10 w-20 text-4xl badge badge-neutral"
       value)))

(pi:define-element page ()
  (pi:h
    (ui:layout
      (section :class "h-full flex justify-center items-center"
        (div :class "flex flex-col items-center gap-4"
          (counter :value *counter*)
          (button
            :hx-target "#counter"
            :hx-post   "/counter/decrease"
            :hx-swap   "outerHTML"
            :class     "btn btn-neutral-content"
            "Decrease -")
          (button
            :hx-target "#counter"
            :hx-post   "/counter/increase"
            :hx-swap   "outerHTML"
            :class     "btn btn-neutral-content"
            "Increase +"))))))

;;; Controller

(defparameter *counter* 0)

(defun index (params)
  (declare (ignore params))
  (jg:with-html-response
    (pi:element-string (page))))

(defun increase (params)
  (declare (ignore params))
  (jg:with-html-response
    (pi:element-string
      (counter :value (incf *counter*)))))

(defun decrease (params)
  (declare (ignore params))
  (jg:with-html-response
    (pi:element-string
      (counter :value (decf *counter*)))))

;;; Routes

(defparameter *index-app* (jg:make-app))

(utils:register-routes
 *index-app*
 `((:method :GET  :path "/"                 :handler ,#'index)
   (:method :POST :path "/counter/increase" :handler ,#'increase)
   (:method :POST :path "/counter/decrease" :handler ,#'decrease)))
