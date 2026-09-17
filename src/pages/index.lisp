(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:website/helper
        #:website/components/icons)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-recent-blog-list)
  (:import-from #:website/components/post-row
                #:~post-row)
  (:import-from #:website/components/link-row
                #:~link-row)
  (:import-from #:website/components/section
                #:~section)
  (:import-from #:website/components/arrow-link
                #:~arrow-link)
  (:export #:@get
           #:@head))
(in-package #:website/pages/index)

(defparameter *links*
  (list
   (list "Keyoxide"
         "https://keyoxide.org/f39d5b2c951d16732a5cd3528f0c1a22f26d7e62"
         (~icon-key :class "size-5"))
   (list "GitHub"
         "https://github.com/skyizwhite"
         (~icon-github :class "size-5"))
   (list "Status"
         "https://status.skyizwhite.dev"
         (~icon-server :class "size-5"))))

(defparameter *contacts*
  (list
   (list "Email"
         "mailto:paku@skyizwhite.dev"
         (~icon-email :class "size-5"))
   (list "Fediverse"
         "https://himagine.club/@skyizwhite"
         (~icon-saturn :class "size-5"))
   (list "Matrix"
         "https://matrix.to/#/@paku:skyizwhite.dev"
         (~icon-chat :class "size-5"))))

(defparameter *pages*
  (list
   (list "About" "/about" (~icon-user :class "size-5"))
   (list "Works" "/works" (~icon-briefcase :class "size-5"))))

(defcomp ~hero ()
  (hsx
   (section :class "pb-8 sm:pb-16"
     (div :class "flex items-center gap-6 sm:gap-10"
       (div :class "flex-1 min-w-0"
         (h1 :class "display text-[clamp(2.5rem,10vw,5rem)]"
           "Akira" (br) "Tempaku")
         (p :class (clsx "mt-4 text-[clamp(1.25rem,4.5vw,2rem)]"
                         "font-bold tracking-tight text-subtle")
           "Software Engineer"))
       (img
         :src (asset-path "img/avatar.webp")
         :alt "avatar" :fetchpriority "high"
         :class "shrink-0 size-24 sm:size-36 rounded-full bg-muted object-cover")))))

(defun @get (params)
  (declare (ignore params))
  (with-cms-fallback ((404 (error-page 404))
                      (t (error-page 500)))
    (set-cache :isr)
    (let ((recent (fetch-recent-blog-list)))
      (hsx
       (<>
         (~hero)
         (ul :class "md:grid md:grid-cols-2 md:gap-x-8"
           (loop
             :for (label url icon) :in *pages* :collect
                (~link-row :label label :href url :icon icon)))
         (~section :heading "Recent Posts"
           :aside (~arrow-link :href "/blog" "View all posts")
           (ul
             (loop
               :for item :in recent :collect
                  (~post-row :id (getf item :id)
                             :title (getf item :title)
                             :published-at (getf item :published-at)))))
         (~section :heading "Contacts"
           (ul :class "md:grid md:grid-cols-2 md:gap-x-8"
             (loop
               :for (name url icon) :in *contacts* :collect
                  (~link-row :label name :href url :icon icon :external t))))
         (~section :heading "Links"
           (ul :class "md:grid md:grid-cols-2 md:gap-x-8"
             (loop
               :for (name url icon) :in *links* :collect
                  (~link-row :label name :href url :icon icon :external t)))))))))

; for health check
(defun @head (params)
  (declare (ignore params)))
