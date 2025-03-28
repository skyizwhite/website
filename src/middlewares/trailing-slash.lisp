(defpackage #:hp/middlewares/trailing-slash
  (:use #:cl)
  (:import-from :quri)
  (:export #:*trim-trailing-slash*))
(in-package #:hp/middlewares/trailing-slash)

(defun last-string (str)
  (subseq str (- (length str) 1)))

(defparameter *trim-trailing-slash*
  (lambda (app)
    (lambda (env)
      (let* ((req-uri (quri:uri (getf env :request-uri)))
             (req-path (quri:uri-path req-uri))
             (req-method (getf env :request-method))
             (response (funcall app env))
             (res-status (first response)))
        (if (and (= res-status 404)
                 (eq req-method :get)
                 (not (string= req-path "/"))
                 (string= (last-string req-path) "/"))
            (let ((red-uri (quri:copy-uri req-uri
                                        :path (string-right-trim "/" req-path))))
              `(301 (:location ,(quri:render-uri red-uri))))
            response)))))
