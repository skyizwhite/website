(defpackage #:hp/routes/about
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:view #:hp/view/**/*))
  (:export #:handle-get))
(in-package #:hp/routes/about)

(defparameter *metadata*
  '(:title "about"
    :description "pakuの自己紹介"))

(pi:define-element page ()
  (pi:h
    (section (view:asset-props :css    "pages/about.css"
                               :js     "pages/about.js"
                               :x-data "aboutPage")
      (h1 "About")
      (a :href "/" :hx-boost "true"
        "top")
      (button :@click "decrement()"
        (span :x-text "count")))))

(defun handle-get (params)
  (declare (ignore params))
  (view:render (page) :metadata *metadata*))
