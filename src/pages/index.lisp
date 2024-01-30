(defpackage #:hp/pages/index
  (:use #:cl)
  (:import-from #:jingle)
  (:import-from #:markup)
  (:import-from #:hp/ui/layout
                #:layout)
  (:import-from #:hp/utils
                #:render-html
                #:register-routes)
  (:export #:*index-app*))
(in-package #:hp/pages/index)

(markup:enable-reader)

(defparameter *counter* 0)

(markup:deftag counter (&key value)
  <div id="counter">,(progn value)</div>)

(defun index-page (params)
  (declare (ignore params))
  (render-html
    <layout>
      <counter value=*counter* /> 
      <button hx-target="#counter" hx-post="/decrease"> - </button>
      <button hx-target="#counter" hx-post="/increase"> + </button>
    </layout>))

(defun increase (params)
  (declare (ignore params))
  (render-html
    <counter value=(incf *counter*) />))

(defun decrease (params)
  (declare (ignore params))
  (render-html
    <counter value=(decf *counter*) />))

(defparameter *index-app* (jingle:make-app))

(register-routes
 *index-app*
 `((:method :GET  :path "/"         :handler ,#'index-page)
   (:method :POST :path "/increase" :handler ,#'increase)
   (:method :POST :path "/decrease" :handler ,#'decrease)))
