(defpackage #:website/pages/blog/<id>
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:ningle-actions
                #:defaction)
  (:import-from #:website/lib/cms
                #:fetch-blog-detail
                #:fetch-blog-likes
                #:update-blog-likes)
  (:import-from #:website/pages/not-found
                #:@not-found)
  (:import-from #:website/components/article
                #:~article)
  (:export #:@get))
(in-package #:website/pages/blog/<id>)

(defaction get-likes :get (params)
  (with-htmx
    (with-request-params ((id "id" nil)) params
      (let ((likes (fetch-blog-likes id)))
        (hsx
         (form 
           :hx-patch (update-likes)
           :hx-swap "outerHTML"
           (input :type "hidden" :name "id" :value id)
           (button :type "submit"
             ;heart icon
             likes
             )))))))

(defaction update-likes :patch (params)
  (with-htmx
    (with-request-params ((id "id" nil)) params
      (let* ((oldLikes (fetch-blog-likes id))
             (newLikes (+ oldLikes 1)))
        (update-blog-likes id newLikes)
        (hsx  
         (div
           ;heart icon
           newLikes
           ))))))

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
       (<>
         (~article
           :title (getf blog :title)
           :content (getf blog :content)
           :published-at (getf blog :published-at)
           :revised-at (getf blog :revised-at)
           :draft-p draft-key)
         (div
           :hx-get (get-likes :id id)
           :hx-trigger "revealed"
           :hx-swap "outerHTML"))))))
