(defpackage #:website/pages/blog/<blog-id>
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:ningle-actions
                #:defaction)
  (:import-from #:website/lib/cms
                #:fetch-blog-detail
                #:fetch-blog-likes
                #:increment-blog-likes)
  (:import-from #:website/pages/not-found
                #:@not-found)
  (:import-from #:website/components/article
                #:~article)
  (:import-from #:website/components/like-button
                #:~like-button
                #:~like-result)
  (:export #:@get))
(in-package #:website/pages/blog/<blog-id>)

(defaction get-likes :get (params)
  (with-htmx
    (with-request-params ((blog-id "blog-id" nil)) params
      (hsx
       (form
         :class "like-form not-prose animate-fade-rise"
         :hx-patch (add-like)
         :hx-swap "outerHTML"
         :hx-disabled-elt "find button"
         (input :type "hidden" :name "blog-id" :value blog-id)
         (~like-button :likes (fetch-blog-likes blog-id)))))))

(defaction add-like :patch (params)
  (with-htmx
    (with-request-params ((blog-id "blog-id" nil)) params
      (hsx (~like-result :likes (increment-blog-likes blog-id))))))

(defun @get (params)
  (with-request-params ((blog-id :blog-id nil)
                        (draft-key "draft-key" nil)) params
    (let ((blog (fetch-blog-detail blog-id :draft-key draft-key)))
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
         (and (not draft-key)
              (hsx (div
                     :class "mt-12 flex items-center justify-center h-11"
                     :hx-get (get-likes :blog-id blog-id)
                     :hx-trigger "revealed"
                     :hx-swap "innerHTML"))))))))
