(defpackage #:website/routes/about
  (:use #:cl
        #:hsx
        #:jingle
        #:access)
  (:import-from #:website/lib/cms
                #:get-about)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime)
  (:export #:handle-get))
(in-package #:website/routes/about)

(defparameter *metadata*
  (list :title "about"))

(defun handle-get (params)
  (setf (context :metadata) *metadata*)
  (with-request-params ((draft-key "draft-key" nil)) params
    (let ((about (get-about :query (list :draft-key draft-key))))
      (hsx
       (<>
         (and draft-key (hsx (p :class "text-lg text-pink-500" "下書きモード")))
         (article :class "prose max-w-none"
           (h1 "About")
           (div  :class "flex justify-center"
             (figure :class "flex flex-col items-center"
               (img
                 :src (accesses about :avatar :url)
                 :alt "avatar" :class "size-40 rounded-xl shadow-sm avatar")
               (figcaption (getf about :avatar-caption))))
           (raw! (getf about :content))
           (p :class "text-right"
             "（最終更新："
             (|time| :datetime (datetime (getf about :revised-at))
                     (jp-datetime (getf about :revised-at)))
             "）")))))))
