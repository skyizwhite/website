(defpackage #:hp/lib/env
  (:use #:cl)
  (:import-from #:cl-dotenv
                #:load-env)
  (:export #:hp-env
           #:hp-url
           #:microcms-service-domain
           #:microcms-api-key))
(in-package #:hp/lib/env)

(load-env (merge-pathnames "./.env"))

(defmacro env-var (name var)
  `(defun ,name ()
     (or (uiop:getenv ,var) "")))

(env-var hp-env "HP_ENV")
(env-var hp-url "HP_URL")
(env-var microcms-service-domain "MICROCMS_SERVICE_DOMAIN")
(env-var microcms-api-key "MICROCMS_API_KEY")
