(defpackage #:hp/components/layout/header
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout-header))
(in-package #:hp/components/layout/header)

(pi:define-element layout-header ()
  (pi:h
    (header :data-css "components/layout/header.css"
      (p "skyizwhite.dev"))))
