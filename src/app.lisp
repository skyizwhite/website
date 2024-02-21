(uiop:define-package #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:import-from #:lack)
  (:export #:*app*
           #:update-routes))
(in-package #:hp/app)

(defparameter *raw-app* (jg:make-app))

(defun update-routes ()
  (fbr:enable-file-based-routing *raw-app*
                                 :dir "src/routes"
                                 :system "hp"
                                 :system-pathname "src"))

(update-routes)

(defparameter *app*
  (lack:builder (:static
                 :path "/dist/assets/"
                 :root (asdf:system-relative-pathname :hp "assets/"))
                *raw-app*))

; for clackup cmd
*app*
