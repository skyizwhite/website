(defpackage #:hp/view/renderer
  (:use #:cl)
  (:local-nicknames (#:jg #:jingle))
  (:local-nicknames (#:pi #:piccolo))
  (:local-nicknames (#:opt #:hp/view/optimizer))
  (:export #:render
           #:partial-render))
(in-package #:hp/view/renderer)

(pi:define-element stylesheets (hrefs)
  (pi:h
    (<> '()
      (mapcar (lambda (href)
                (link :rel "stylesheet" :type "text/css" :href href))
              hrefs))))

(pi:define-element document (title description)
  (let* ((children-str (pi:elem-str pi:children))
         (style-links (opt:collect-style-links children-str)))
    (pi:h
      (html :lang "ja"
        (head
          (meta :charset "UTF-8")
          (script :src "/scripts/htmx.js")
          (script :src "/scripts/htmx-ext/head-support.js")
          (script :src "/scripts/alpine.js" :defer t)
          (link :rel "stylesheet" :type "text/css" :href "/styles/ress.css")
          (link :rel "stylesheet" :type "text/css" :href "/styles/global.css")
          (link :rel "preconnect" :href "https://fonts.googleapis.com")
          (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
          (link 
            :rel "stylesheet"
            :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap")
          (title (format nil "~@[~a - ~]skyizwhite.dev" title))
          (meta
            :name "description"
            :content (or description "pakuの個人サイト"))
          (stylesheets :hrefs style-links))
        (body :hx-ext "head-support"
          (main pi:children))))))

(pi:define-element assets-provider ()
  (let* ((child-str (pi:elem-str pi:children))
         (style-links (opt:collect-style-links child-str)))
    (pi:h
      (<>
        (head :hx-head "append"
          (stylesheets :hrefs style-links))
        pi:children))))

(defun render (page &key status metadata)
  (jg:with-html-response
    (and status (jg:set-response-status status))
    (pi:elem-str (document metadata page))))

(defun partial-render (component &key status)
  (jg:with-html-response
    (and status (jg:set-response-status status))
    (pi:elem-str (assets-provider component))))
