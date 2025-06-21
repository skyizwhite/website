(defpackage #:website/pages/works
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:fetch-works)
  (:import-from #:website/components/article
                #:~article)
  (:export #:handle-get))
(in-package #:website/pages/works)

(defparameter *metadata*
  (list :title "works"))

(defun handle-get (params)
  (set-metadata *metadata*)
  (with-request-params ((draft-key "draft-key" nil)) params
    (set-cache (if draft-key :ssr :isr))
    (let ((works (fetch-works :draft-key draft-key)))
      (~article
        :title "Works"
        :content (getf works :content)
        :revised-at (getf works :revised-at)
        :draft-p draft-key))))
