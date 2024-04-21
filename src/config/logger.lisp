(defpackage #:hp/config/logger
  (:use #:cl)
  (:import-from #:log4cl))
(in-package #:hp/config/logger)

(log:config :nofile)
