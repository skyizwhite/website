(defpackage #:hp/middlewares/access-blocker
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:*access-blocker*))
(in-package #:hp/middlewares/access-blocker)

(defparameter *access-blocker*
  (lambda (app)
    (lambda (env)
      (let ((user-agent (gethash "user-agent" (getf env :headers))))
        (if (re:scan "(Firefox|SamsungBrowser)" user-agent)
            `(:400
              (:content-type "text/plain")
              ("This site is not compatible with your browser. Please use Chrome, Edge, Safari, or another compatible browser."))
            (funcall app env))))))
