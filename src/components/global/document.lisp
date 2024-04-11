(defpackage #:hp/components/global/document
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:document))
(in-package #:hp/components/global/document)

(pi:define-element document (metadata)
  (pi:h
    (html :lang "ja"
      metadata
      (body :hx-ext "head-support"
        pi:children))))
