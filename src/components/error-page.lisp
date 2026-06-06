(defpackage #:website/components/error-page
  (:use #:cl
        #:hsx)
  (:export #:~error-page))
(in-package #:website/components/error-page)

(defcomp ~error-page (&key status title message)
  (hsx
   (div :class "flex flex-col h-full items-center justify-center gap-6 py-20 text-center"
     (p :class "font-display text-[120px] sm:text-[160px] font-bold leading-none accent-text"
       status)
     (div :class "flex flex-col gap-2"
       (h1 :class "font-display font-bold text-2xl tracking-tight"
         title)
       (p :class "text-sm text-muted"
         message))
     (a :href "/"
       :class (clsx "mt-4 inline-flex items-center gap-2 px-5 py-2.5 rounded-full"
                    "accent-gradient text-white font-display font-semibold text-sm"
                    "hover:shadow-glow hover:-translate-y-0.5 transition-all duration-200")
       (img
         :src "/assets/img/icon/arrow-left.svg"
         :class "size-4" :alt "" :aria-hidden "true")
       "Back to home"))))
