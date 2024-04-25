(defpackage #:hp/components/layout/footer
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout-footer))
(in-package #:hp/components/layout/footer)

(pi:define-element layout-footer ()
  (pi:h
    (footer :data-css "components/layout/footer.css")))
