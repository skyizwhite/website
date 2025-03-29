(defpackage #:hp/middlewares/recoverer
  (:use #:cl
        #:hsx)
  (:import-from #:trivial-backtrace
                #:print-backtrace)
  (:import-from #:hp/env
                #:hp-env)
  (:export #:*recoverer*))
(in-package #:hp/middlewares/recoverer)

(defun error-page (condition)
  (hsx
   (html :lang "ja"
     (head
       (title "Internal Server Error"))
     (body
       (main
         (h1 "500 Internal Server Error")
         (when (string= (hp-env) "dev")
           (hsx
            (pre
              (code (print-backtrace condition :output nil))))))))))

(defparameter *recoverer*
  (lambda (app)
    (lambda (env)
      (handler-case
          (funcall app env)
        (error (c)
          `(500 (:content-type "text/html; charset=utf-8")
                (,(hsx:render-to-string (error-page c)))))))))
