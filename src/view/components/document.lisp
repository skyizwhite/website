(defpackage #:hp/view/components/document
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:asset #:hp/view/asset))
  (:local-nicknames (#:cfg #:hp/config/asset))
  (:export #:document
           #:partial-document))
(in-package #:hp/view/components/document)

(pi:define-element on-demand-stylesheets ()
  (let* ((html-str (pi:elem-str pi:children))
         (css-links (asset:get-css-links html-str)))
    (pi:h
      (<>
        (mapcar (lambda (href)
                  (link :rel "stylesheet" :type "text/css" :href href))
                css-links)))))

(pi:define-element document (title description)
  (pi:h
    (html :lang "ja"
      (head
        (meta :charset "UTF-8")
        (link
          :rel "stylesheet"
          :type "text/css"
          :href (cfg:asset-path :vendor "ress@5.0.2.css"))
        (link
          :rel "stylesheet"
          :type "text/css"
          :href (cfg:asset-path :style "global.css"))
        (on-demand-stylesheets pi:children)
        (link :rel "preconnect" :href "https://fonts.googleapis.com")
        (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
        (link 
          :rel "stylesheet"
          :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap")
        (script :src (cfg:asset-path :vendor "htmx@1.9.12.js"))
        (script :src (cfg:asset-path :vendor "htmx-ext/alpine-morph@1.9.12.js"))
        (script :src (cfg:asset-path :vendor "htmx-ext/head-support@1.9.12.js"))
        (script :src (cfg:asset-path :vendor "alpine-ext/async-alpine@1.2.2.js") :defer t)
        (script :src (cfg:asset-path :vendor "alpine-ext/persist@3.13.8.js") :defer t)
        (script :src (cfg:asset-path :vendor "alpine-ext/morph@3.13.8.js") :defer t)
        (script :src (cfg:asset-path :script "global.js") :defer t)
        (script :src (cfg:asset-path :vendor "alpine@3.13.8.js") :defer t)
        (title (format nil "~@[~a - ~]skyizwhite.dev" title))
        (meta
          :name "description"
          :content (or description "pakuの個人サイト")))
      pi:children)))

(pi:define-element partial-document ()
  (pi:h
    (<>
      (head :hx-head "append"
        (on-demand-stylesheets pi:children))
      pi:children)))
