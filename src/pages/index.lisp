(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:website/helper
        #:website/components/icons)
  (:import-from #:website/lib/cms
                #:with-cms-fallback
                #:fetch-recent-blog-list)
  (:import-from #:website/components/blog-card
                #:~blog-card)
  (:export #:@get
           #:@head))
(in-package #:website/pages/index)

(defparameter *links*
  (list
   (list "Keyoxide"
         "https://keyoxide.org/f39d5b2c951d16732a5cd3528f0c1a22f26d7e62"
         (~icon-key :class "size-4"))
   (list "GitHub"
         "https://github.com/skyizwhite"
         (~icon-github :class "size-4"))
   (list "Status"
         "https://status.skyizwhite.dev"
         (~icon-server :class "size-4"))))

(defparameter *contacts*
  (list
   (list "Fediverse"
         "https://himagine.club/@skyizwhite"
         (~icon-saturn :class "size-4"))
   (list "Matrix"
         "https://matrix.to/#/@paku:skyizwhite.dev"
         (~icon-chat :class "size-4"))
   (list "Email"
         "mailto:paku@skyizwhite.dev"
         (~icon-email :class "size-4"))))

(defparameter *pages*
  (list
   (list "About" "/about" (~icon-user :class "size-5"))
   (list "Works" "/works" (~icon-briefcase :class "size-5"))))

(defun @get (params)
  (declare (ignore params))
  (with-cms-fallback ((404 (error-page 404))
                      (t (error-page 500)))
    (set-cache :isr)
    (let ((recent (fetch-recent-blog-list)))
      (hsx
       (<>
         (section :class "flex flex-col items-center text-center pt-6 sm:pt-10"
           (div :class "relative mb-8"
             (div :class "absolute -inset-1 rounded-[28px] accent-gradient opacity-70 blur-md")
             (div :class "relative rounded-[24px] p-[2px] accent-gradient"
               (img
                 :src "/assets/img/avatar.webp"
                 :alt "avatar"
                 :class "block size-40 sm:size-44 rounded-[22px] bg-base object-cover")))
           (h1 :class "font-display font-bold text-4xl sm:text-5xl tracking-tight"
             "Akira Tempaku")
           (p :class "mt-2 text-sm uppercase tracking-[0.35em] text-muted font-display"
             "Software Engineer"))
         (section :class "mt-12 grid grid-cols-1 sm:grid-cols-2 gap-3"
           (loop
             :for (label url icon) :in *pages*
             :collect
                (hsx
                 (a
                   :href url
                   :class (clsx "group flex items-center gap-3 px-5 py-4 rounded-2xl"
                                "border border-base surface"
                                "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                                "transition-all duration-200")
                   (span :class (clsx "inline-flex items-center justify-center size-10 rounded-xl"
                                      "bg-muted group-hover:accent-gradient transition-colors")
                     icon)
                   (span :class "text-base font-display font-semibold tracking-wide"
                     label)
                   (~icon-arrow-right :class "size-4 ml-auto text-muted group-hover:text-fg transition-colors")))))
         (section :class "mt-16 sm:mt-20"
           (h2 :class "font-display font-bold text-2xl sm:text-3xl tracking-tight text-fg mb-6"
             "Recent Posts")
           (ul :class "flex flex-col gap-2"
             (loop
               :for item :in recent :collect
                  (~blog-card :id (getf item :id)
                    :title (getf item :title)
                    :published-at (getf item :published-at))))
           (div :class "mt-6 text-center"
             (a
               :href "/blog"
               :class (clsx "inline-flex items-center gap-2 px-5 py-2.5 rounded-full"
                            "border border-base surface text-sm font-display font-semibold tracking-wide"
                            "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                            "transition-all duration-200")
               "View all posts"
               (~icon-arrow-right :class "size-4"))))
         (section :class "mt-16 sm:mt-20"
           (h2 :class "font-display font-bold text-2xl sm:text-3xl tracking-tight text-fg mb-6"
             "Contacts")
           (div :class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3"
             (loop
               :for (name url icon) :in *contacts*
               :collect
                  (hsx
                   (a
                     :href url :target "_blank" :rel "me noopener"
                     :class (clsx "group flex items-center gap-3 px-4 py-3 rounded-2xl"
                                  "border border-base surface"
                                  "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                                  "transition-all duration-200")
                     (span :class (clsx "inline-flex items-center justify-center size-9 rounded-xl"
                                        "bg-muted group-hover:accent-gradient transition-colors")
                       icon)
                     (span :class "text-sm font-display font-semibold tracking-wide"
                       name))))))
         (section :class "mt-16 sm:mt-20"
           (h2 :class "font-display font-bold text-2xl sm:text-3xl tracking-tight text-fg mb-6"
             "Links")
           (div :class "grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3"
             (loop
               :for (name url icon) :in *links*
               :collect
                  (hsx
                   (a
                     :href url :target "_blank" :rel "me noopener"
                     :class (clsx "group flex items-center gap-3 px-4 py-3 rounded-2xl"
                                  "border border-base surface"
                                  "hover:border-strong hover:-translate-y-0.5 hover:shadow-glow"
                                  "transition-all duration-200")
                     (span :class (clsx "inline-flex items-center justify-center size-9 rounded-xl"
                                        "bg-muted group-hover:accent-gradient transition-colors")
                       icon)
                     (span :class "text-sm font-display font-semibold tracking-wide"
                       name)))))))))))

; for health check
(defun @head (params)
  (declare (ignore params)))
