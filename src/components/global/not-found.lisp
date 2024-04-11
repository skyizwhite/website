(defpackage #:hp/components/global/not-found
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:not-found-page))
(in-package #:hp/components/global/not-found)

(pi:define-element not-found-page ()
  (pi:h
    (section
      (h1 "404 Not Found"))))
