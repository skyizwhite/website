(uiop:define-package #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:import-from #:lack)
  (:local-nicknames (#:utils #:hp/utils/*))
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app*
  (let ((app (jg:make-app)))
    (utils:enable-file-based-routing app
                                     :dir "src/routes"
                                     :system "hp"
                                     :system-pathname "src")
    (lack:builder (:static
                   :path "/static/"
                   :root (asdf:system-relative-pathname :hp "static/"))
                  app)))

; for clackup cmd
*app*
