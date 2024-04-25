(defpackage #:hp/components/document/seo
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:seo))
(in-package #:hp/components/document/seo)

(pi:define-element seo (title description)
  (pi:h
    (<>
      (title (format nil "~@[~a - ~]skyizwhite.dev" title))
      (meta
        :name "description"
        :content (or description "pakuの個人サイト")))))
