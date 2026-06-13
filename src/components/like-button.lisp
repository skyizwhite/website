(defpackage #:website/components/like-button
  (:use #:cl
        #:hsx
        #:website/components/icons)
  (:export #:~like-button
           #:~like-toast))
(in-package #:website/components/like-button)

(defparameter *pill-class*
  "inline-flex items-center gap-2.5 rounded-full px-5 py-2.5 font-display font-semibold text-sm tabular-nums")

(defcomp ~like-button (&key likes disabled nm-bind)
  (if disabled
      (hsx
       (button :type "button"
         :disabled t
         :aria-label "You liked this post"
         :class (clsx *pill-class*
                      "cursor-default text-accent-200"
                      "border border-accent-500/40 bg-accent-500/10")
         (~icon-heart :class "size-5")
         (span :class "text-lg" likes)))
      (hsx
       (button :type "button"
         :aria-label "Like this post"
         :nm-bind nm-bind
         :class (clsx *pill-class*
                      "group relative cursor-pointer text-fg"
                      "border border-strong bg-muted"
                      "hover:border-accent-500/60 hover:bg-accent-500/10 hover:text-accent-100"
                      "active:scale-95 transition-all duration-200"
                      "animate-fade-rise")
         (span :class "like-content inline-flex items-center gap-2.5"
           (~icon-heart :class "size-5 transition-transform group-hover:scale-110")
           (span :class "text-lg" likes))
         (~icon-spinner :class "like-spinner absolute inset-0 m-auto size-5 animate-spin")))))

(defcomp ~like-toast (&key (message "Thank you!"))
  (hsx
   (div
     :nm-data "{ phase: 'init' }"
     :nm-bind "{
       oninit: () => {
         requestAnimationFrame(() => requestAnimationFrame(() => phase = 'shown'));
         setTimeout(() => phase = 'leaving', 3000);
       },
       'class.translate-y-1': () => phase === 'init',
       'class.translate-y-0': () => phase !== 'init',
       'class.opacity-0': () => phase === 'leaving'
     }"
     :role "status"
     :aria-live "polite"
     :class (clsx "absolute bottom-full left-1/2 -translate-x-1/2 mb-3 z-50 w-max pointer-events-none"
                  "transition duration-300 ease-out translate-y-1")
     (div :class (clsx *pill-class*
                       "whitespace-nowrap"
                       "border border-accent-500/40 bg-accent-500/10 text-accent-200"
                       "backdrop-blur-md shadow-glow")
       (~icon-heart :class "size-5")
       (span :class "text-lg" message)))))
