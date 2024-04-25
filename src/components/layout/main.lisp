(defpackage #:hp/components/layout/main
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:import-from #:hp/components/layout/header
                #:layout-header)
  (:import-from #:hp/components/layout/footer
                #:layout-footer)
  (:export #:layout))
(in-package #:hp/components/layout/main)

(pi:define-element layout ()
  (pi:h
    (body
      :hx-ext cfg:*hx-ext*
      :data-css "components/layout/main.css"
      (layout-header)
      (main :class "main"
        pi:children)
      (layout-footer)
      )))
