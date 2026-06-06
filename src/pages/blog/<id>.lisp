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
                #:increment-likes)
  (:import-from #:website/pages/not-found
                #:@not-found)
  (:import-from #:website/components/article
                #:~article)
  (:import-from #:website/components/like-button
                #:~like-button
                #:~like-result)
  (:export #:@get))
(in-package #:website/pages/blog/<id>)

(defaction get-likes :get (params)
  (with-htmx
    (with-request-params ((id "id" nil)) params
      (hsx
       (form
         :class "like-form not-prose animate-fade-rise"
         :hx-patch (add-like)
         :hx-swap "outerHTML"
         :hx-disabled-elt "find button"
         (input :type "hidden" :name "id" :value id)
         (~like-button :likes (fetch-blog-likes id)))))))

(defaction add-like :patch (params)
  (with-htmx
    (with-request-params ((id "id" nil)) params
      (hsx
       (~like-result :likes (increment-likes id))))))

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
         (and (not draft-key)
              (hsx (div
                     ;; Fixed-height container reserved up front so lazily
                     ;; revealed like content swaps in without shifting layout.
                     :class "mt-12 flex items-center justify-center h-[2.625rem]"
                     :hx-get (get-likes :id id)
                     :hx-trigger "revealed"
                     :hx-swap "innerHTML"))))))))
