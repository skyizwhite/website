(defpackage #:website/lib/cookie
  (:use #:cl)
  (:import-from #:jingle
                #:*request*
                #:*response*
                #:request-cookies
                #:response-set-cookies)
  (:export #:get-cookie
           #:set-cookie))
(in-package #:website/lib/cookie)

(defun get-cookie (name)
  "Return the value of the request cookie NAME, or NIL if absent."
  (cdr (assoc name (request-cookies *request*) :test #'string=)))

(defun set-cookie (name value &key (path "/")
                                   (max-age (* 365 24 60 60))
                                   (http-only t)
                                   (same-site :lax)
                                   (secure t))
  "Queue a Set-Cookie header on the current response. MAX-AGE is in
seconds and is translated to an absolute `expires' timestamp; pass NIL
to omit expiry (session cookie). Existing queued cookies are preserved."
  (setf (response-set-cookies *response*)
        (append (response-set-cookies *response*)
                (list name (list :value value
                                 :path path
                                 :expires (and max-age
                                               (+ (get-universal-time) max-age))
                                 :httponly http-only
                                 :samesite same-site
                                 :secure secure)))))
