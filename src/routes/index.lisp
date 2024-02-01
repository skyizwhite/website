(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:mk #:markup))
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:ui #:hp/ui/*))
  (:local-nicknames (#:utils #:hp/utils/*))
  (:export #:*index-app*))
(in-package #:hp/routes/index)

(mk:enable-reader)

;;; View

(mk:deftag page ()
  <ui:layout>
    <h1>Hello HTMX from Common Lisp!</h1>
  </ui:layout>)

;;; Controller

(defun index (params)
  (declare (ignore params))
  (jg:with-html-response
    (mk:write-html <page />)))

(defparameter *index-app* (jg:make-app))

(utils:register-routes
 *index-app*
 `((:method :GET :path "/" :handler ,#'index)))
