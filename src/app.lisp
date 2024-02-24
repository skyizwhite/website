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
  (lack:builder :accesslog
                (:static
                 :path "/assets/"
                 :root (asdf:system-relative-pathname :hp "dist/assets/"))
                (:static
                 :path "/public/"
                 :root (asdf:system-relative-pathname :hp "public/"))
                *raw-app*))

; for clackup cmd
*app*
