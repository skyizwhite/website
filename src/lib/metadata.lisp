(defpackage #:hp/lib/metadata
  (:use #:cl)
  (:import-from #:hp/lib/env
                #:hp-url)
  (:export #:complete-metadata))
(in-package #:hp/lib/metadata)

(defun path->url (path)
  (concatenate 'string
               (hp-url)
               (and (not (string= path "/")) path)))

(defparameter *metadata-template*
  (list :title (lambda (title) (format nil "~@[~a - ~]~a" title "skyizwhite.dev"))
        :description "The personal website of Akira Tempaku (paku) - projects, thoughts, and more."
        :canonical #'path->url
        :og-url #'path->url
        :og-type "website"
        :og-image (path->url "/img/og.jpg")
        :og-image-width 1024
        :og-image-height 1024))

(defun complete-metadata (metadata)
  (loop 
    :for (key template) :on *metadata-template* :by #'cddr
    :for value := (getf metadata key)
    :append (list key (if (functionp template)
                          (funcall template value)
                          (or value template)))))
