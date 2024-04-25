(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view/*))
  (:export #:handle-get))
(in-package #:hp/routes/index)

(pi:define-element page ()
  (pi:h
    (div :class "h-full place-content-center"
      (h1
        :x-data "{flag: true}"
        :@click "flag = ! flag"
        :class "text-4xl text-center"
        :|:class| "flag ? 'text-red-400' : 'text-blue-400'"
        "Hello, world!"))))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page)))
