(defpackage #:website/lib/env
  (:use #:cl)
  (:import-from #:cl-dotenv
                #:load-env)
  (:export #:website-url
           #:koya-url
           #:koya-api-key
           #:koya-webhook-key
           #:redis-host
           #:redis-port
           #:dev-mode-p))
(in-package #:website/lib/env)

(let ((env-path "./.env"))
  (when (probe-file env-path)
    (load-env env-path)))

(defmacro env-var (name var &optional optionalp)
  `(defun ,name ()
     (let ((value (or (uiop:getenv ,var) "")))
       (when (and (not ,optionalp) (uiop:emptyp value))
         (error "Environment variable ~a is empty" ,var))
       value)))

(env-var website-env "WEBSITE_ENV" :optional)
(env-var website-url "WEBSITE_URL")
(env-var koya-url "KOYA_URL")
(env-var koya-api-key "KOYA_API_KEY")
(env-var koya-webhook-key "KOYA_WEBHOOK_KEY")
(env-var redis-host "REDIS_HOST")
(env-var redis-port "REDIS_PORT")

(defun dev-mode-p ()
  (string= (website-env) "dev"))
