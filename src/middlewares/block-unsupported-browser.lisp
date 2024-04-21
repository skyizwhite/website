(defpackage #:hp/middlewares/block-unsupported-browser
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:*block-unsupported-browser*))
(in-package #:hp/middlewares/block-unsupported-browser)

(defparameter *block-unsupported-browser*
  (lambda (app)
    (lambda (env)
      (let ((user-agent (gethash "user-agent" (getf env :headers))))
        (if (re:scan "(Firefox|SamsungBrowser)" user-agent)
            `(:400
              (:content-type "text/plain")
              ("This site is not compatible with your browser. Please use Chrome, Edge, Safari, or another compatible browser."))
            (funcall app env))))))
