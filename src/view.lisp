(defpackage #:hp/view
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:export #:render
           #:partial-render))
(in-package #:hp/view)

(defun render (page &key status metadata)
  (jg:with-html-response
    (and status (jg:set-response-status status))
    (pi:elem-str (cmp:document metadata
                   (cmp:layout page)))))

(defun partial-render (component &key status)
  (jg:with-html-response
    (and status (jg:set-response-status status))
    (pi:elem-str component)))
