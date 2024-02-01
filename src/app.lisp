(defpackage #:hp/app
  (:use #:cl)
  (:local-nicknames (#:routes #:hp/routes/*))
  (:import-from #:lack)
  (:export #:*app*))
(in-package #:hp/app)

(defparameter *app*
  (lack:builder (:static
                 :path "/static/"
                 :root (asdf:system-relative-pathname :hp "static/"))
                routes:*index-app*))

; for clackup cmd
*app*
