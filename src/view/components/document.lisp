(defpackage #:hp/view/components/document
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:asset #:hp/view/asset))
  (:export #:document
           #:partial-document))
(in-package #:hp/view/components/document)

(pi:define-element on-demand-stylesheets ()
  (let* ((pi:*escape-html* nil)
         (html-str (pi:elem-str pi:children))
         (css-paths (asset:get-css-paths html-str)))
    (pi:h
      (<>
        (mapcar (lambda (path)
                  (link :rel "stylesheet" :type "text/css" :href path))
                css-paths)))))

(pi:define-element stylesheets ()
  (pi:h
    (<>
      (link :rel "stylesheet" :type "text/css" :href asset:*ress*)
      (link :rel "stylesheet" :type "text/css" :href asset:*global-css*)
      (on-demand-stylesheets pi:children)
      (link :rel "preconnect" :href "https://fonts.googleapis.com")
      (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
      (link 
        :rel "stylesheet"
        :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap"))))

(pi:define-element extentions (paths defer)
  (pi:h
    (<>
      (mapcar (lambda (path)
                (script :src path :defer defer))
              paths))))

(pi:define-element scripts ()
  (pi:h
    (<>
      (script :src asset:*htmx*)
      (extentions :paths asset:*htmx-extentions*)
      (extentions :paths asset:*alpine-extentions* :defer t)
      (script :src asset:*global-js* :defer t)
      (script :src asset:*alpine* :defer t))))

(pi:define-element seo (title description)
  (pi:h
    (<>
      (title (format nil "~@[~a - ~]skyizwhite.dev" title))
      (meta
        :name "description"
        :content (or description "pakuの個人サイト")))))

(pi:define-element document (metadata)
  (pi:h
    (html :lang "ja"
      (head
        (meta :charset "UTF-8")
        (stylesheets pi:children)
        (scripts)
        (seo metadata))
      pi:children)))

(pi:define-element partial-document ()
  (pi:h
    (<>
      (head :hx-head "append"
        (on-demand-stylesheets pi:children))
      pi:children)))
