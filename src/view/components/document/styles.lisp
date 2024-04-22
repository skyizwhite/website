(defpackage #:hp/view/components/document/styles
  (:use #:cl)
  (:local-nicknames (#:pi #:piccolo))
  (:import-from #:hp/view/asset
                #:define-asset
                #:get-css-paths)
  (:export #:on-demand-styles
           #:styles))
(in-package #:hp/view/components/document/styles)

(define-asset *ress*
  :vendor "ress@5.0.2.css")

(define-asset *global-css*
  :css "global.css")

(pi:define-element on-demand-styles ()
  (let* ((pi:*escape-html* nil)
         (html-str (pi:elem-str pi:children))
         (css-paths (get-css-paths html-str)))
    (pi:h
      (<>
        (mapcar (lambda (path)
                  (link :rel "stylesheet" :type "text/css" :href path))
                css-paths)))))

(pi:define-element styles ()
  (pi:h
    (<>
      (link :rel "stylesheet" :type "text/css" :href *ress*)
      (link :rel "stylesheet" :type "text/css" :href *global-css*)
      (on-demand-styles pi:children)
      (link :rel "preconnect" :href "https://fonts.googleapis.com")
      (link :rel "preconnect" :href "https://fonts.gstatic.com" :crossorigin t)
      (link 
        :rel "stylesheet"
        :href "https://fonts.googleapis.com/css2?family=Noto+Sans+JP:wght@400;700&display=swap"))))
