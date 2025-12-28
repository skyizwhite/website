(defpackage #:website/document
  (:use #:cl
        #:hsx)
  (:import-from #:website/components/metadata
                #:~metadata)
  (:export #:~document))
(in-package #:website/document)

(defcomp ~document (&key children)
  (hsx
   (html :lang "ja"
     (head
       (~metadata)
       (script :type "module"
         (raw!
           "import sprae from 'https://cdn.jsdelivr.net/npm/sprae@12.3.5/+esm';"
           "sprae(document.body);")))
     (body children))))

(defun add-cache-buster (url)
  (format nil "~a?v=~a" url #.(get-universal-time)))
