(defpackage #:website/lib/env
  (:use #:cl)
  (:import-from #:cl-dotenv
                #:load-env)
  (:export #:website-env
           #:website-url
           #:microcms-service-domain
           #:microcms-api-key
           #:dev-mode-p))
(in-package #:website/lib/env)

(let ((env-path "./.env"))
  (when (probe-file env-path)
    (load-env env-path)))

(defmacro env-var (name var)
  `(defun ,name ()
     (or (uiop:getenv ,var) "")))

(env-var website-env "WEBSITE_ENV")
(env-var website-url "WEBSITE_URL")
(env-var microcms-service-domain "MICROCMS_SERVICE_DOMAIN")
(env-var microcms-api-key "MICROCMS_API_KEY")
(env-var microcms-webhook-key "MICROCMS_WEBHOOK_KEY")

(defun dev-mode-p ()
  (string= (website-env) "dev"))
