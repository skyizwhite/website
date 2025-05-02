(defpackage #:website/lib/env
  (:use #:cl)
  (:import-from #:cl-dotenv
                #:load-env)
  (:export #:website-env
           #:website-url
           #:microcms-service-domain
           #:microcms-api-key))
(in-package #:website/lib/env)

(load-env (merge-pathnames "./.env"))

(defmacro env-var (name var)
  `(defun ,name ()
     (or (uiop:getenv ,var) "")))

(env-var website-env "WEBSITE_ENV")
(env-var website-url "WEBSITE_URL")
(env-var microcms-service-domain "MICROCMS_SERVICE_DOMAIN")
(env-var microcms-api-key "MICROCMS_API_KEY")
