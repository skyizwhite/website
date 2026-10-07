(defpackage #:website/lib/http
  (:use #:cl)
  (:import-from #:ningle
                #:*request*
                #:*response*)
  (:import-from #:lack/request
                #:request-headers)
  (:import-from #:lack/response
                #:response-headers
                #:response-status)
  (:export #:set-response-header
           #:set-response-status
           #:get-request-header
           #:with-request-params))
(in-package #:website/lib/http)

(defun set-response-header (name value)
  (setf (response-headers *response*)
        (append (response-headers *response*) (list name value))))

(defun set-response-status (status)
  (setf (response-status *response*) status))

(defun get-request-header (name)
  (gethash (string-downcase name) (request-headers *request*)))

(defmacro with-request-params (bindings params &body body)
  (let ((alist (gensym "PARAMS")))
    `(let ((,alist ,params))
       (let ,(loop :for (var name default) :in bindings
                   :collect `(,var (or (cdr (assoc ,name ,alist :test #'equal))
                                       ,default)))
         ,@body))))
