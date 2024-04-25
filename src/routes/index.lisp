(defpackage #:hp/routes/index
  (:use #:cl
        #:piccolo)
  (:local-nicknames (#:view #:hp/view/*))
  (:export #:handle-get))
(in-package #:hp/routes/index)

(define-element page ()
  (div :class "h-full place-content-center"
    (h1
      :x-data "{
         flag: true,
         toggle() {
           this.flag = !this.flag
         }
       }"
      :@click "toggle"
      :class "text-4xl text-center"
      :|:class| "flag ? 'text-red-400' : 'text-blue-400'"
      "Hello, world!")))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page)))
