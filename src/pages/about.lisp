(defpackage #:website/pages/about
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-about)
  (:import-from #:website/components/article
                #:~article)
  (:export #:@get))
(in-package #:website/pages/about)

(defparameter *metadata*
  (list :title "about"))

(defun @get (params)
  (with-cms-fallback ((404 (error-page 404))
                      (t (error-page 500)))
    (set-metadata *metadata*)
    (with-request-params ((draft-key "draft-key" nil)) params
      (set-cache (if draft-key :ssr :isr))
      (let ((about (fetch-about :draft-key draft-key)))
        (~article
          :title "About"
          :content (getf about :content)
          :draft-p draft-key)))))
