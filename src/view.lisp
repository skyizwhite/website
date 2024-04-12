(defpackage #:hp/view
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cmp #:hp/components/**/*))
  (:export #:render))
(in-package #:hp/view)

(defun render (page &key status title description)
  (jg:with-html-response
    (and status (jg:set-response-status status))
    (pi:elem-str
     (let ((md (cmp:metadata :title title :description description))
           (body (cmp:layout page)))
       (if (jg:get-request-header "HX-Boosted")
           (pi:h (<> md body))
           (pi:h (cmp:document :metadata md
                   body)))))))
