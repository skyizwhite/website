(defpackage #:website/components/metadata
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/env
                #:website-url)
  (:export #:~metadata))
(in-package #:website/components/metadata)

(defun path->url (path)
  (concatenate 'string
               (website-url)
               (and (not (string= path "/")) path)))

(defun complete-metadata (metadata)
  (loop 
    :for (key template) :on *default-metadata* :by #'cddr
    :for value := (getf metadata key)
    :append (list key (if (functionp template)
                          (funcall template value)
                          (or value template)))))

(defparameter *default-metadata*
  (list :title (lambda (title) (format nil "~@[~a - ~]skyizwhite" title))
        :description "The personal website of Akira Tempaku (paku)"
        :canonical nil
        :type "website"
        :image (list :url (path->url "/assets/img/og.jpg")
                     :height 1024
                     :width 1024)
        :error nil))

(defcomp ~metadata ()
  (destructuring-bind (&key title
                            description
                            canonical
                            type
                            image
                            error)
      (complete-metadata (context :metadata))
    (let ((path (request-uri *request*)))
      (hsx
       (<>
         (meta :charset "UTF-8")
         (meta :name "viewport" :content "width=device-width, initial-scale=1")
         (title title)
         (meta :name "description" :content description)
         (and (not error)
              (hsx (<>
                     (meta :property "og:title" :content title)
                     (meta :property "og:description" :content description)
                     (meta :property "og:url" :content (path->url path))
                     (meta :property "og:type" :content type)
                     (meta :property "og:site_name" :content "skyizwhite")
                     (meta :property "og:image" :content (getf image :url))
                     (meta :property "og:image:width" :content (getf image :width))
                     (meta :property "og:image:height" :content (getf image :height))
                     (link :rel "canonical" :href (path->url (or canonical path))))))
         (link :rel "icon" :type "image/png" :href "/assets/img/favicon-96x96.png" :sizes "96x96")
         (link :rel "icon" :type "image/svg+xml" :href "/assets/img/favicon.svg")
         (link :rel "shortcut icon" :href "/assets/img/favicon.ico")
         (link :rel "apple-touch-icon" :sizes "180x180" :href "/assets/img/apple-touch-icon.png"))))))
