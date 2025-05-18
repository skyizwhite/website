(defpackage #:website/routes/about
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:get-about)
  (:import-from #:website/components/article
                #:~article)
  (:export #:handle-get))
(in-package #:website/routes/about)

(defparameter *metadata*
  (list :title "about"))

(defun handle-get (params)
  (setf (context :metadata) *metadata*)
  (with-request-params ((draft-key "draft-key" nil)) params
    (setf (context :no-cache) draft-key)
    (let ((about (get-about :query (list :draft-key draft-key))))
      (~article
        :title "About"
        :content (getf about :content)
        :revised-at (getf about :revised-at)
        :draft-p draft-key))))
