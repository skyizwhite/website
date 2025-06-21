(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:flexi-streams
                #:make-flexi-stream)
  (:import-from #:jonathan
                #:parse)
  (:import-from #:website/lib/env
                #:dev-mode-p)
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
  (cond ((dev-mode-p)
         (set-response-header :cache-control "private, no-store, must-revalidate"))
        ((eq strategy :ssr)
         (set-response-header :cache-control "public, max-age=0, must-revalidate"))
        ((eq strategy :isr)
         (set-response-header :cache-control "public, max-age=0, s-maxage=60, stale-while-revalidate=60"))
        ((eq strategy :sg)
         (set-response-header :cache-control "public, max-age=0, s-maxage=31536000, must-revalidate"))))
