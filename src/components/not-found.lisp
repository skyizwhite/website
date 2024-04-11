(uiop:define-package #:hp/components/not-found
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:import-from #:hp/components/layout
                #:layout)
  (:export #:not-found-page))
(in-package #:hp/components/not-found)

(pi:define-element not-found-page ()
  (pi:h
    (layout
      (section
        (h1 "404 Not Found")))))
