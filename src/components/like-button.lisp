(defpackage #:website/components/like-button
  (:use #:cl
        #:hsx)
  (:export #:~like-button
           #:~like-result
           #:~like-toast))
(in-package #:website/components/like-button)

(defparameter *pill-class*
  "inline-flex items-center gap-2.5 rounded-full px-5 py-2.5 font-display font-semibold text-sm tabular-nums")

(defun ~heart (&optional (class "size-5"))
  (hsx
   (img :src "/assets/img/icon/heart.svg"
     :class class
     :alt "" :aria-hidden "true")))

(defcomp ~like-button (&key likes)
  (hsx
   (button :type "submit"
     :aria-label "Like this post"
     :class (clsx *pill-class*
                  "group relative cursor-pointer text-fg"
                  "border border-strong bg-muted"
                  "hover:border-accent-500/60 hover:bg-accent-500/10 hover:text-accent-100"
                  "active:scale-95 transition-all duration-200")
     (span :class "like-content inline-flex items-center gap-2.5"
       (~heart "size-5 transition-transform group-hover:scale-110")
       (span :class "text-lg" likes))
     (img :src "/assets/img/icon/spinner.svg"
       :class "like-spinner absolute inset-0 m-auto size-5 animate-spin"
       :alt "" :aria-hidden "true"))))

(defcomp ~like-toast (&key (message "Thank you!"))
  (hsx
   (div
     :x-data "{ show: false }"
     :x-init "$nextTick(() => (show = true)); setTimeout(() => (show = false), 3000)"
     :x-show "show"
     :x-cloak t
     :|x-transition:enter| "transition ease-out duration-300"
     :|x-transition:enter-start| "translate-y-1"
     :|x-transition:enter-end| "translate-y-0"
     :|x-transition:leave| "transition ease-in duration-300"
     :|x-transition:leave-start| "opacity-100"
     :|x-transition:leave-end| "opacity-0"
     :role "status"
     :aria-live "polite"
     :class "absolute bottom-full left-1/2 -translate-x-1/2 mb-3 z-50 w-max pointer-events-none"
     (div :class (clsx *pill-class*
                       "whitespace-nowrap"
                       "border border-accent-500/40 bg-accent-500/10 text-accent-200"
                       "backdrop-blur-md shadow-glow")
       (~heart "size-5")
       (span :class "text-lg" message)))))

(defcomp ~like-result (&key likes)
  (hsx
   (div :class "not-prose relative"
     (~like-toast)
     (div :class (clsx *pill-class*
                       "border border-accent-500/40 bg-accent-500/10 text-accent-200")
       (~heart "size-5")
       (span :class "text-lg" likes)))))
