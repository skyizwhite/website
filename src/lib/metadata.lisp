(defpackage #:hp/lib/metadata
  (:use #:cl
        #:hsx)
  (:import-from #:hp/lib/env
                #:hp-url)
  (:export #:~metadata))
(in-package #:hp/lib/metadata)

(defun create-metadata (&key title
                             description
                             path
                             canonical
                             type
                             image
                             error)
  (list :title title
        :description description
        :canonical (or canonical path)
        :og-title title
        :og-description description
        :og-url path
        :og-type type
        :og-image (getf image :url)
        :og-image-width (getf image :width)
        :og-image-height (getf image :height)
        :error error))

(defun path->url (path)
  (concatenate 'string
               (hp-url)
               (and (not (string= path "/")) path)))

(defparameter *metadata-template*
  (let ((%title (lambda (title) (format nil "~@[~a - ~]~a" title "skyizwhite.dev")))
        (%description "The personal website of Akira Tempaku (paku) - bio, work, blog and more."))
    (list :title %title
          :description %description
          :canonical #'path->url
          :og-title %title
          :og-description %description
          :og-url #'path->url
          :og-type "website"
          :og-site-name "skyizwhite.dev"
          :og-image (path->url "/img/og.jpg")
          :og-image-width 1024
          :og-image-height 1024
          :error nil)))

(defun complete-metadata (metadata)
  (loop 
    :for (key template) :on *metadata-template* :by #'cddr
    :for value := (getf metadata key)
    :append (list key (if (functionp template)
                          (funcall template value)
                          (or value template)))))

(defcomp ~metadata (&key metadata)
  (let ((%metadata (complete-metadata (apply #'create-metadata metadata))))
    (hsx
     (<>
       (title (getf %metadata :title))
       (meta :name "description" :content (getf %metadata :description))
       (and
        (not (getf %metadata :error))
        (hsx
         (<>
           (meta :property "og:title" :content (getf %metadata :og-title))
           (meta :property "og:description" :content (getf %metadata :og-description))
           (meta :property "og:url" :content (getf %metadata :og-url))
           (meta :property "og:type" :content (getf %metadata :og-type))
           (meta :property "og:site_name" :content (getf %metadata :og-site-name))
           (meta :property "og:image" :content (getf %metadata :og-image))
           (meta :property "og:image:width" :content (getf %metadata :og-image-width))
           (meta :property "og:image:height" :content (getf %metadata :og-image-height))
           (link :rel "canonical" :href (getf %metadata :canonical)))))))))
