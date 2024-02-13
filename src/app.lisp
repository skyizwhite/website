(uiop:define-package #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:import-from #:lack)
  (:local-nicknames (#:utils #:hp/utils/*))
  (:export #:*app*
           #:update-routes))
(in-package #:hp/app)

(defparameter *raw-app* (jg:make-app))

(defun update-routes ()
  (utils:enable-file-based-routing *raw-app*
                                   :dir "src/routes"
                                   :system "hp"
                                   :system-pathname "src"))

(update-routes)

(defparameter *app*
  (lack:builder (:static
                 :path "/static/"
                 :root (asdf:system-relative-pathname :hp "static/"))
                *raw-app*))

; for clackup cmd
*app*
