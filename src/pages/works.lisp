(defpackage #:website/pages/works
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-works)
  (:import-from #:website/components/article
                #:~article)
  (:export #:@get))
(in-package #:website/pages/works)

(defparameter *metadata*
  (list :title "works"))

(defun @get (params)
  (with-cms-fallback ((404 (error-page 404))
                      (t (error-page 500)))
    (set-metadata *metadata*)
    (with-request-params ((draft-key "draft-key" nil)) params
      (set-cache (if draft-key :ssr :isr))
      (let ((works (fetch-works :draft-key draft-key)))
        (~article
          :title "Works"
          :content (getf works :content)
          :draft-p draft-key)))))
