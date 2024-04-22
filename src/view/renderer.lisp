(defpackage #:hp/view/renderer
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cfg #:hp/config/env))
  (:local-nicknames (#:cmp #:hp/view/components/**/*))
  (:export #:render
           #:partial-render))
(in-package #:hp/view/renderer)

(defun renderer ()
  (if (cfg:dev-mode-p)
      #'pi:element-string
      #'pi:elem-str))

(defun render (page &key status metadata)
  (jg:with-html-response
    (if status (jg:set-response-status status))
    (funcall (renderer) (cmp:document :metadata metadata
                          (cmp:layout page)))))

(defun partial-render (component &key status)
  (jg:with-html-response
    (if status (jg:set-response-status status))
    (funcall (renderer) (cmp:partial-document component))))
