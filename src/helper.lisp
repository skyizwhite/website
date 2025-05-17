(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:flexi-streams
                #:make-flexi-stream)
  (:import-from #:jonathan
                #:parse)
  (:export #:api-request-p
           #:get-request-body-plist))
(in-package #:website/helper)

(defun starts-with-p (prefix string)
  (let ((pos (search prefix string :start1 0 :end1 (length prefix) :start2 0)))
    (and pos (= pos 0))))

(defun api-request-p ()
  (starts-with-p "/api/" (request-uri *request*)))

(defun get-request-body-plist ()
  (parse
   (let ((text-stream (make-flexi-stream (request-raw-body *request*)
                                         :external-format :utf-8)))
     (with-output-to-string (out)
       (loop :for char := (read-char text-stream nil)
             :while char
             :do (write-char char out))))))
