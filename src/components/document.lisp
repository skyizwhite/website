(defpackage #:hp/components/document
  (:use #:cl
        #:hsx)
  (:export #:document))
(in-package #:hp/components/document)

(defcomp document (&key title description children)
  (hsx
   (html :lang "ja"
     (head
       (meta :charset "UTF-8")
       (title (format nil "~@[~a - ~]skyizwhite.dev" title))
       (meta
         :name "description"
         :content (or description "pakuの個人サイト")))
     children)))
