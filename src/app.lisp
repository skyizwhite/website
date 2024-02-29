(uiop:define-package #:hp/app
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:fbr #:ningle-fbr))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:import-from #:lack)
  (:export #:*app*
           #:update-routes))
(in-package #:hp/app)

(defparameter *raw-app* (jg:make-app))

(defmethod jg:not-found ((app jg:app))
  (jg:with-html-response
    (jg:set-response-status 404)
    (pi:element-string (cmp:not-found-page))))

(defun update-routes ()
  (fbr:enable-file-based-routing *raw-app*
                                 :system "hp"
                                 :directory "src/routes"))

(update-routes)

(defun exist-public-file-p (path)
  (let ((pathname (probe-file (concatenate 'string "public" path))))
    (and pathname
         (pathname-name pathname))))

(defparameter *app*
  (lack:builder :accesslog
                (:static
                 :path (lambda (path)
                         (if (exist-public-file-p path) 
                             path
                             nil))
                 :root (asdf:system-relative-pathname :hp "public/"))
                *raw-app*))

; for clackup cmd
*app*
