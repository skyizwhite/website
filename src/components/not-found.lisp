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
      (section :class "h-full flex justify-center items-center"
        (h1 :class "text-error text-4xl"
          "404 Not Found")))))
