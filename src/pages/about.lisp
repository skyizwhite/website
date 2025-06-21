(defpackage #:website/pages/about
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:fetch-about)
  (:import-from #:website/components/article
                #:~article)
  (:export #:handle-get))
(in-package #:website/pages/about)

(defparameter *metadata*
  (list :title "about"))

(defun handle-get (params)
  (set-metadata *metadata*)
  (with-request-params ((draft-key "draft-key" nil)) params
    (set-cache (if draft-key :ssr :isr))
    (let ((about (fetch-about :draft-key draft-key)))
      (~article
        :title "About"
        :content (getf about :content)
        :revised-at (getf about :revised-at)
        :draft-p draft-key))))
