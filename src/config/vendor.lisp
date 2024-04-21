(defpackage #:hp/config/vendor
  (:use #:cl)
  (:import-from #:log4cl))
(in-package #:hp/config/vendor)

(log:config :nofile)
