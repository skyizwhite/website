(defpackage #:website/components/like-button
  (:use #:cl
        #:hsx
        #:website/components/icons)
  (:import-from #:website/lib/string
                #:squish)
  (:export #:~like-button
           #:~like-toast))
(in-package #:website/components/like-button)

(defparameter *shape-class*
  "inline-flex items-center gap-3 h-12 rounded-full border pl-5 pr-6 tabular-nums")

(defcomp ~like-button (&key likes disabled class rest)
  (if disabled
      (hsx
       (button (append (list :type "button"
                             :disabled t
                             :aria-label "You liked this post"
                             :class (clsx *shape-class*
                                          "cursor-not-allowed border-transparent bg-muted text-fg"
                                          class))
                       rest)
         (~icon-heart :class "size-5")
         (span :class "text-base font-bold" likes)))
      (hsx
       (button (append (list :type "button"
                             :aria-label "Like this post"
                             :class (clsx *shape-class*
                                          "group relative cursor-pointer"
                                          "border-strong bg-base text-muted"
                                          "hover:bg-invert hover:border-ink-900 hover:text-invert"
                                          "active:scale-95 animate-fade-rise"
                                          class))
                       rest)
         (span :class "like-content inline-flex items-center gap-3"
           (~icon-heart-outline :class "size-5 transition-transform group-hover:scale-115")
           (span :class "text-base font-bold" likes))
         (~icon-spinner :class "like-spinner absolute inset-0 m-auto size-5 animate-spin")))))

(defcomp ~like-toast (&key (message "Thank you!"))
  (hsx
   (div
     :n-let-phase "'init'"
     :n-on-init (squish "
       requestAnimationFrame(() => requestAnimationFrame(() => phase = 'shown'));
       setTimeout(() => phase = 'leaving', 3000);
     ")
     :n-bind-class.translate-y-1 "phase === 'init'"
     :n-bind-class.translate-y-0 "phase !== 'init'"
     :n-bind-class.opacity-0 "phase === 'leaving'"
     :role "status"
     :aria-live "polite"
     :class (clsx "absolute bottom-full right-0 mb-3 z-50 w-max pointer-events-none"
                  "transition duration-300 ease-ui translate-y-1")
     (div :class (clsx *shape-class*
                       "whitespace-nowrap border-transparent bg-invert text-invert shadow-pop")
       (~icon-heart :class "size-5")
       (span :class "text-base font-bold" message)))))
