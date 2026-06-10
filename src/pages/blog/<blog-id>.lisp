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
                (hsx (div
                       :id "like-section"
                       :class "mt-12 flex items-center justify-center h-11"
                       :nm-bind (reveal-likes-bind blog-id))))))))))

(defun reveal-likes-bind (blog-id)
  (format nil "{
    oninit: (e) => {
      const io = new IntersectionObserver((es) => {
        if (es[0].isIntersecting) {
          io.disconnect();
          $get('~a');
        }
      });
      io.observe(e.target);
    }
  }"
          (get-likes :blog-id blog-id)))


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
            ;; Already liked on a previous visit: show the liked state
            ;; (no form, no toast).
            (hsx
             (div :id "like-section" :class "mt-12 flex items-center justify-center"
               (div :class "not-prose animate-fade-rise"
                 (~like-button :likes (fetch-blog-likes blog-id) :disabled t))))
            (hsx
             (div :id "like-section" :class "mt-12 flex items-center justify-center"
               (~like-button :likes (fetch-blog-likes blog-id)
                 :bind (like-button-bind blog-id)))))))))

(defun like-button-bind (blog-id)
  (format nil "{
    onclick: () => $fetch('~a', 'PATCH', { 'blog-id': '~a' }),
    'class.is-fetching': () => _nmFetching,
    disabled: () => _nmFetching
  }"
          (add-like) blog-id))


(defaction add-like :patch (params)
  (with-nm-request
    (with-request-params ((blog-id "blog-id" nil)) params
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
           (div :id "like-form" :class "not-prose relative"
             (~like-toast)
             (~like-button :likes likes :disabled t))))))))
