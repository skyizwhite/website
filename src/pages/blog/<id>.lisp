(defpackage #:website/pages/blog/<id>
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:fetch-blog-detail)
  (:import-from #:website/pages/not-found
                #:@not-found)
  (:import-from #:website/components/article
                #:~article)
  (:export #:@get))
(in-package #:website/pages/blog/<id>)

(defun @get (params)
  (with-request-params ((id :id nil)
                        (draft-key "draft-key" nil)) params
    (let ((blog (fetch-blog-detail id :draft-key draft-key)))
      (unless blog
        (return-from @get (@not-found)))
      (set-cache (if draft-key :ssr :isr))
      (set-metadata (list :title (getf blog :title)
                          :description (getf blog :description)
                          :type "article"))
      (hsx
       (~article
         :title (getf blog :title)
         :content (getf blog :content)
         :published-at (getf blog :published-at)
         :revised-at (getf blog :revised-at)
         :draft-p draft-key)))))
