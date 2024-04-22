(defpackage #:hp/view/components/document/main
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:import-from #:hp/view/components/document/styles
                #:styles
                #:on-demand-styles)
  (:import-from #:hp/view/components/document/scripts
                #:scripts)
  (:import-from #:hp/view/components/document/seo
                #:seo)
  (:export #:document
           #:partial-document))
(in-package #:hp/view/components/document/main)

(pi:define-element document (metadata)
  (pi:h
    (html :lang "ja"
      (head
        (meta :charset "UTF-8")
        (styles pi:children)
        (scripts)
        (seo metadata))
      pi:children)))

(pi:define-element partial-document ()
  (pi:h
    (<>
      (head :hx-head "append"
        (on-demand-styles pi:children))
      pi:children)))
