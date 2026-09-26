(defpackage #:website/pages/blog/<blog-id>
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:ningle-actions
                #:defaction)
  (:import-from #:website/lib/string
                #:squish)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-blog-detail)
  (:import-from #:website/lib/likes
                #:fetch-blog-likes
                #:increment-blog-likes)
  (:import-from #:website/lib/liked-posts
                #:liked-post-p
                #:mark-post-liked)
  (:import-from #:website/components/article
                #:~article)
  (:import-from #:website/components/like-button
                #:~like-button
                #:~like-toast)
  (:import-from #:website/components/arrow-link
                #:~arrow-link)
  (:export #:@get))
(in-package #:website/pages/blog/<blog-id>)

(defun @get (params)
  (with-request-params ((blog-id :blog-id nil)
                        (draft-key "draft-key" nil)) params
    (with-cms-fallback ((404 (error-page 404))
                        (t (error-page 500)))
      (let ((blog (fetch-blog-detail blog-id :draft-key draft-key)))
        (set-cache (if draft-key :ssr :swr))
        (set-draft-mode draft-key)
        (set-metadata (list :title (getf blog :title)
                            :description (getf blog :description)
                            :type "article"))
        (hsx
         (<>
           (~article
             :title (getf blog :title)
             :content (getf blog :content)
             :published-at (getf blog :published-at))
           (div :class (clsx "mt-12 pt-6 sm:mt-16 sm:pt-8 border-t border-base"
                             "flex flex-wrap items-center justify-between gap-x-6 gap-y-5")
             (~arrow-link :href "/blog" :direction :back "Back to blog")
             (and (not draft-key)
                  (hsx
                   (div :class "h-12"
                     (div
                       :id "like-button" :nm-data t
                       :data-action (get-likes :blog-id blog-id)
                       :nm-bind (squish "{
                                   oninit: (e) => {
                                     const action = $dataset().action;
                                     const io = new IntersectionObserver((es) => {
                                       if (es[0].isIntersecting) {
                                         io.disconnect();
                                         $get(action);
                                       }
                                     });
                                     io.observe(e.target);
                                   }
                                 }"))))))))))))

(defun no-store ()
  (set-response-header :cache-control "private, no-store"))

(defaction get-likes :get (params)
  (with-nm-request
    (with-request-params ((blog-id "blog-id" nil)) params
      (unless blog-id
        (return-from get-likes (error-action 400)))
      (no-store)
      (with-cms-fallback ((404 (error-action 404))
                          (t (error-action 500)))
        (fetch-blog-detail blog-id)
        (if (liked-post-p blog-id)
            (hsx
             (div :id "like-button" :class "h-12 animate-fade-rise"
               (~like-button :likes (fetch-blog-likes blog-id) :disabled t)))
            (hsx
             (div
               :id "like-button"
               :nm-data t :data-action (add-like) :data-blog-id blog-id
               (~like-button
                 :likes (fetch-blog-likes blog-id)
                 :nm-bind (squish "{
                             onclick: () => $post($dataset().action),
                             'class.is-fetching': () => _nmFetching,
                             disabled: () => _nmFetching
                           }")))))))))

(defaction add-like :post (params)
  (with-nm-request
    (with-request-params ((blog-id "blogId" nil)) params
      (unless blog-id
        (return-from add-like (error-action 400)))
      (no-store)
      (when (liked-post-p blog-id)
        (return-from add-like (error-action 409)))
      (with-cms-fallback ((404 (error-action 404))
                          (t (error-action 500)))
        (fetch-blog-detail blog-id)
        (let ((likes (increment-blog-likes blog-id)))
          (mark-post-liked blog-id)
          (hsx
           (div :id "like-button" :class "h-12 relative"
             (~like-toast)
             (~like-button :likes likes :disabled t))))))))
