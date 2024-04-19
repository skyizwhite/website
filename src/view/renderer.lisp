(defpackage #:hp/view/renderer
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cfg #:hp/config))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:export #:render
           #:partial-render))
(in-package #:hp/view/renderer)

(defun render (page &key status metadata)
  (jg:with-html-response
    (jg:set-response-status (or status :ok))
    (pi:elem-str (cmp:document metadata
                   (cmp:layout page)))))

(defun partial-render (component &key status)
  (jg:with-html-response
    (jg:set-response-status (or status :ok))
    (pi:elem-str component)))
