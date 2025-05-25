(defpackage #:website/routes/api/revalidate
  (:use #:cl
        #:jingle
        #:access)
  (:import-from #:website/lib/env
                #:microcms-webhook-key)
  (:import-from #:website/helper
                #:get-request-body-plist)
  (:import-from #:website/lib/cms
                #:*get-about-cache*
                #:*get-works-cache*
                #:*get-blog-list-cache*
                #:*get-blog-detail-cache*)
  (:import-from #:website/lib/cache
                #:clear-cache
                #:clear-cache-partial-arguments)
  (:export #:handle-post))
(in-package #:website/routes/api/revalidate)

(defun handle-post (params)
  (declare (ignore params))
  (unless (string= (car (get-request-header "X-MICROCMS-WEBHOOK-KEY"))
                   (microcms-webhook-key))
    (set-response-status :unauthorized)
    (return-from handle-post '(:|message| "Invalid token")))
  (let* ((body (get-request-body-plist))
         (api (getf body :|api|))
         (id (getf body :|id|))
         (old-draft-key (accesses body :|contents| :|old| :|draftKey|))
         (new-draft-key (accesses body :|contents| :|new| :|draftKey|)))
    (cond ((string= api "about")
           (if new-draft-key
               (clear-cache-partial-arguments *get-about-cache*
                                              (list :query (list :draft-key new-draft-key)))
               (clear-cache *get-about-cache*)))
          ((string= api "works")
           (if new-draft-key
               (clear-cache-partial-arguments *get-works-cache*
                                              (list :query (list :draft-key new-draft-key)))
               (clear-cache *get-works-cache*)))
          ((string= api "blog")
           (unless new-draft-key
             (clear-cache *get-blog-list-cache*)
             (clear-cache-partial-arguments *get-blog-detail-cache*
                                            (list id :query (list :draft-key old-draft-key))))
           (clear-cache-partial-arguments *get-blog-detail-cache*
                                          (list id :query (list :draft-key new-draft-key)))))
    (list :|api| api
          :|id| id
          :|old-draft-key| old-draft-key
          :|new-draft-key| new-draft-key
          :|message| "ok")))
