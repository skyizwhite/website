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
       (script :src "https://cdn.jsdelivr.net/npm/htmx.org@2.0.8/dist/htmx.min.js")
       (style *style*)
       (~metadata))
     (body children))))

(defparameter *style* "
@view-transition {
  navigation: auto;
}

body {
  background-color: black;
}

h1,p {
  color: red;
}
")
