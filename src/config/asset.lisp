(defpackage #:hp/config/asset
  (:use #:cl)
  (:export #:*asset-roots*))
(in-package #:hp/config/asset)

(defparameter *asset-roots*
  '(:img "/img/"
    :css "/css/"
    :js "/js/"
    :vendor "/vendor/"
    :htmx-ext "/vendor/htmx-ext/"
    :alpine-ext "/vendor/alpine-ext/"))
