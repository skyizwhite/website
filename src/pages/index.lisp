(defpackage #:hp/pages/index
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:mk #:markup))
  (:local-nicknames (#:ui #:hp/ui/*))
  (:local-nicknames (#:utils #:hp/utils/*))
  (:export #:*index-app*))
(in-package #:hp/pages/index)

(mk:enable-reader)

(defparameter *counter* 0)

(mk:deftag counter (&key id value)
  <div id=id >,(progn value)</div>)

(defun index-page (params)
  (declare (ignore params))
  (jg:with-html-response
    (mk:write-html
     <ui:layout>
       <counter id="counter" value=*counter* /> 
       <button hx-target="#counter" hx-post="/decrease"> - </button>
       <button hx-target="#counter" hx-post="/increase"> + </button>
     </ui:layout>)))

(defun increase (params)
  (declare (ignore params))
  (jg:with-html-response
    (mk:write-html <counter id="counter" value=(incf *counter*) />)))

(defun decrease (params)
  (declare (ignore params))
  (jg:with-html-response
    (mk:write-html <counter id= "counter" value=(decf *counter*) />)))

(defparameter *index-app* (jg:make-app))

(utils:register-routes
 *index-app*
 `((:method :GET  :path "/"         :handler ,#'index-page)
   (:method :POST :path "/increase" :handler ,#'increase)
   (:method :POST :path "/decrease" :handler ,#'decrease)))
