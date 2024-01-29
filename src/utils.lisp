(defpackage #:hp/utils
  (:use #:cl)
  (:import-from #:markup)
  (:import-from #:jingle)
  (:export #:register-routes
           #:render-html))
(in-package #:hp/utils)

(defun register-routes (app routes)
  (loop :for item :in routes
        :for path    = (getf item :path)
        :for handler = (getf item :handler)
        :for method  = (getf item :method)
        :do (setf (jingle:route app path :method method) handler)))

(defmacro render-html (&body body)
  `(jingle:with-html-response
     (markup:write-html
      ,@body)))
