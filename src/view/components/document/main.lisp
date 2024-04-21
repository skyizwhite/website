(defpackage #:hp/view/components/document/main
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:import-from #:hp/view/components/document/stylesheets
                #:stylesheets
                #:on-demand-stylesheets)
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
        (stylesheets pi:children)
        (scripts)
        (seo metadata))
      pi:children)))

(pi:define-element partial-document ()
  (pi:h
    (<>
      (head :hx-head "append"
        (on-demand-stylesheets pi:children))
      pi:children)))
