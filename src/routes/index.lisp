(defpackage #:hp/routes/index
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view/**/*))
  (:export #:handle-get))
(in-package #:hp/routes/index)

(pi:define-element page ()
  (pi:h
    (section (view:asset-props :css    "pages/index.css"
                               :js     "pages/index.js"
                               :x-data "indexPage")
      (h1
        "Hello, World!")
      (a :href "/about" :hx-boost "true"
        "About")
      (button :x-data t :@click "$store.darkMode.toggle()"
        "Toggle theme")
      (button
        :@click "increment()"
        (span :x-text "count")))))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page)))
