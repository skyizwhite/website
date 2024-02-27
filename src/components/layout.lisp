(uiop:define-package #:hp/components/layout
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:export #:layout))
(in-package #:hp/components/layout)

(pi:define-element layout ()
  (pi:h
    (html
      (head
        (title "skyizwhite.dev")
        (script :type "module" :src "http://localhost:5173/@vite/client")
        (script :type "module" :src "http://localhost:5173/src/assets/main.js"))
      (body :hx-ext "debug, alpine-morph, head-support" :class "h-[100svh] w-screen"
        (main :class "h-full"
          pi:children)))))
