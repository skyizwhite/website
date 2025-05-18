(defpackage #:website/routes/works
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:get-works)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package #:website/routes/works)

(defparameter *metadata*
  (list :title "works"))

(defun handle-get (params)
  (setf (context :metadata) *metadata*)
  (with-request-params ((draft-key "draft-key" nil)) params
    (setf (context :no-cache) draft-key)
    (let ((works (get-works :query (list :draft-key draft-key))))
      (hsx
       (<>
         (and draft-key (hsx (p :class "text-lg text-pink-500" "下書きモード")))
         (article :class "prose max-w-none"
           (h1 "Works")
           (raw! (getf works :content))
           (p :class "text-right"
             "（最終更新："
             (|time| :datetime (datetime (getf works :revised-at))
                     (jp-datetime (getf works :revised-at)))
             "）")))))))
