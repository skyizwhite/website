(defpackage #:hp/components/not-found
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:not-found-page))
(in-package #:hp/components/not-found)

(pi:define-element not-found-page ()
  (pi:h
    (section
      (h1 "404 Not Found"))))
