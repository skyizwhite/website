(defpackage #:website/routes/blog/<id>
  (:use #:cl
        #:hsx
        #:jingle)
  (:import-from #:website/lib/cms
                #:fetch-blog-detail)
  (:import-from #:website/routes/not-found
                #:handle-not-found)
  (:import-from #:website/components/article
                #:~article)
  (:export #:handle-get))
(in-package #:website/routes/blog/<id>)

(defun handle-get (params)
  (with-request-params ((id :id nil)
                        (draft-key "draft-key" nil)) params
    (let ((blog (fetch-blog-detail id :draft-key draft-key)))
      (unless blog
        (return-from handle-get (handle-not-found)))
      (setf (context :cache) (if draft-key :ssr :isr))
      (setf (context :metadata) (list :title (getf blog :title)
                                      :description (getf blog :description)
                                      :type "article"))
      (hsx
       (~article
         :title (getf blog :title)
         :content (getf blog :content)
         :published-at (getf blog :published-at)
         :revised-at (getf blog :revised-at)
         :draft-p draft-key)))))
