(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:website/helper
        #:website/components/icons)
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
   (list "ActivityPub"
         "https://himagine.club/@skyizwhite"
         (~icon-activitypub :class "size-4"))
   (list "Matrix"
         "https://matrix.to/#/@paku:skyizwhite.dev"
         (~icon-matrix :class "size-4"))
   (list "Email"
         "mailto:paku@skyizwhite.dev"
         (~icon-email :class "size-4"))
   (list "Status"
         "https://status.skyizwhite.dev"
         (~icon-server :class "size-4"))))

(defun @get (params)
  (declare (ignore params))
  (set-cache :sg)
  (hsx
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
       "Software Engineer")
     (div :class "mt-12 w-full grid grid-cols-1 sm:grid-cols-2 md:grid-cols-3 gap-3"
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
                 name))))))))

; for health check
(defun @head (params)
  (declare (ignore params)))
