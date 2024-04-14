(defpackage #:hp/view/optimizer
  (:use #:cl)
  (:local-nicknames (#:re #:cl-ppcre))
  (:export #:collect-style-links))
(in-package #:hp/view/optimizer)

(defun detect-components (page-str)
  (remove-duplicates (re:all-matches-as-strings "(?<=data-cmp=\")[^\"]*(?=\")"
                                                page-str)
                     :test #'string=))

(defun components->stylesheets (data-cmps)
  (mapcar (lambda (cmp-name)
            (concatenate 'string "/styles/" cmp-name ".css"))
          data-cmps))

(defun collect-style-links (page-str)
  (components->stylesheets (detect-components page-str)))
