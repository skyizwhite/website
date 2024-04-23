(defpackage #:hp/config/lib
  (:use #:cl)
  (:import-from #:log4cl))
(in-package #:hp/config/lib)

(log:config :nofile)
