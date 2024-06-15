(defpackage #:hp/response
  (:use #:cl)
  (:import-from #:hsx)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:cmp #:hp/components/*))
  (:export #:response
           #:partial-response))
(in-package #:hp/response)

(defun response (page &key status metadata)
  (jg:with-html-response
    (if status (jg:set-response-status status))
    (hsx:render-to-string (cmp:document metadata
                            (cmp:layout page)))))

(defun partial-response (component &key status)
  (jg:with-html-response
    (if status (jg:set-response-status status))
    (hsx:render-to-string component)))
