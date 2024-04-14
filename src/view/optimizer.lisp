(defpackage #:hp/view/optimizer
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:collect-style-links))
(in-package #:hp/view/optimizer)

(defun detect-scopes (html-str)
  (remove-duplicates (re:all-matches-as-strings "(?<=data-scope=\")[^\"]*(?=\")"
                                                html-str)
                     :test #'string=))

(defun scopes->stylesheets (scopes)
  (mapcar (lambda (scope)
            (concatenate 'string "/styles/" scope ".css"))
          scopes))

(defun collect-style-links (html-str)
  (scopes->stylesheets (detect-scopes html-str)))
