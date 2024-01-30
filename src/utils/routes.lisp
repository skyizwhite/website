(defpackage #:hp/utils/routes
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:export #:register-routes))
(in-package #:hp/utils/routes)

(defun register-routes (app routes)
  (loop :for item :in routes
        :for path    = (getf item :path)
        :for handler = (getf item :handler)
        :for method  = (getf item :method)
        :do (setf (jg:route app path :method method) handler)))
