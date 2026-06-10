(defpackage #:website/components/like-button
  (:use #:cl
        #:hsx)
  (:export #:~like-button
           #:~like-toast))
(in-package #:website/components/like-button)

(defparameter *pill-class*
  "inline-flex items-center gap-2.5 rounded-full px-5 py-2.5 font-display font-semibold text-sm tabular-nums")

(defun ~heart (&optional (class "size-5"))
  (hsx
   (img :src "/assets/img/icon/heart.svg"
     :class class
     :alt "" :aria-hidden "true")))

(defcomp ~like-button (&key likes disabled)
  "The like pill. When DISABLED, renders the static \"already liked\" state
(non-interactive, accent-colored, no spinner); otherwise the clickable
submit button."
  (if disabled
      (hsx
       (button :type "button"
         :disabled t
         :aria-label "You liked this post"
         :class (clsx *pill-class*
                      "cursor-default text-accent-200"
                      "border border-accent-500/40 bg-accent-500/10")
         (~heart "size-5")
         (span :class "text-lg" likes)))
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
           :alt "" :aria-hidden "true")))))

(defcomp ~like-toast (&key (message "Thank you!"))
  (hsx
   (div
     :nm-data "{ show: false }"
     :nm-bind "{ oninit: () => { requestAnimationFrame(() => show = true); setTimeout(() => show = false, 3000); }, 'class.opacity-100': () => show, 'class.opacity-0': () => !show, 'class.translate-y-0': () => show, 'class.translate-y-1': () => !show }"
     :role "status"
     :aria-live "polite"
     :class (clsx "absolute bottom-full left-1/2 -translate-x-1/2 mb-3 z-50 w-max pointer-events-none"
                  "transition duration-300 ease-out opacity-0 translate-y-1")
     (div :class (clsx *pill-class*
                       "whitespace-nowrap"
                       "border border-accent-500/40 bg-accent-500/10 text-accent-200"
                       "backdrop-blur-md shadow-glow")
       (~heart "size-5")
       (span :class "text-lg" message)))))
