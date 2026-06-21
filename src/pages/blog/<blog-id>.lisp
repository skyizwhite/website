(defpackage #:website/pages/blog/<blog-id>
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:import-from #:ningle-actions
                #:defaction)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-blog-detail
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
  (:import-from #:website/components/icons
                #:~icon-arrow-left)
  (:export #:@get))
(in-package #:website/pages/blog/<blog-id>)

(defun @get (params)
  (with-request-params ((blog-id :blog-id nil)
                        (draft-key "draft-key" nil)) params
    (with-cms-fallback ((404 (error-page 404))
                        (t (error-page 500)))
      (let ((blog (fetch-blog-detail blog-id :draft-key draft-key)))
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
             :draft-p draft-key)
           (and (not draft-key)
                (hsx
                 (div :class "mt-12 flex items-center justify-center h-11"
                   (div
                     :id "like-button" :nm-data t
                     :data-action (get-likes :blog-id blog-id)
                     :nm-bind "{
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
                     }"))))
           (div :class "mt-12 not-prose"
             (a
               :href "/blog"
               :class (clsx "group inline-flex items-center gap-2"
                            "text-sm font-display font-semibold"
                            "text-muted hover:text-fg transition-colors")
               (~icon-arrow-left
                 :class "size-4 transition-transform group-hover:-translate-x-0.5")
               "Back to blog"))))))))

;; Like state is per-visitor (it depends on their cookie), so these
;; fragments must never be shared by a cache.
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
        (if (liked-post-p blog-id)
            (hsx
             (div :id "like-button" :class "not-prose animate-fade-rise"
               (~like-button :likes (fetch-blog-likes blog-id) :disabled t)))
            (hsx
             (div
               :id "like-button"
               :nm-data t :data-action (add-like) :data-blog-id blog-id
               (~like-button
                 :likes (fetch-blog-likes blog-id)
                 :nm-bind "{
                             onclick: () => $fetch($dataset().action, 'PATCH'),
                             'class.is-fetching': () => _nmFetching,
                             disabled: () => _nmFetching
                           }"))))))))

(defaction add-like :patch (params)
  (with-nm-request
    (with-request-params ((blog-id "blogId" nil)) params
      (unless blog-id
        (return-from add-like (error-action 400)))
      (no-store)
      (when (liked-post-p blog-id)
        (return-from add-like (error-action 409)))
      (with-cms-fallback ((404 (error-action 404))
                          (t (error-action 500)))
        (let ((likes (increment-blog-likes blog-id)))
          (mark-post-liked blog-id)
          (hsx
           (div :id "like-button" :class "not-prose relative"
             (~like-toast)
             (~like-button :likes likes :disabled t))))))))
