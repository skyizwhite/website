(defpackage #:hp/view/responser
  (:use #:cl)
  (:import-from #:hsx
                #:render)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:cfg #:hp/config/env))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:export #:response
           #:partial-response))
(in-package #:hp/view/responser)

(defun response (page &key status metadata)
  (jg:with-html-response
    (if status (jg:set-response-status status))
    (render (cmp:document :metadata metadata
              (cmp:layout page))
            :minify t)))

(defun partial-response (component &key status)
  (jg:with-html-response
    (if status (jg:set-response-status status))
    (render component :minify t)))
