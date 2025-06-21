(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:flexi-streams
                #:make-flexi-stream)
  (:import-from #:jonathan
                #:parse)
  (:export #:request-body-json->plist
           #:set-metadata
           #:set-cache))
(in-package #:website/helper)

(defun request-body-json->plist ()
  (parse
   (let ((text-stream (make-flexi-stream (request-raw-body *request*)
                                         :external-format :utf-8)))
     (with-output-to-string (out)
       (loop :for char := (read-char text-stream nil)
             :while char
             :do (write-char char out))))))

(defun set-metadata (metadata)
  (setf (context :metadata) metadata))

(defun set-cache (strategy)
  (setf (context :cache) strategy))
