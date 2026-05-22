(defpackage #:website/pages/not-found
  (:use #:cl
        #:hsx
        #:jingle
        #:website/helper)
  (:export #:@not-found))
(in-package #:website/pages/not-found)

(defparameter *metadata*
  '(:title "404 Not Found"
    :description "The page you are looking for may have been deleted or the URL might be incorrect."
    :error t))

(defun @not-found ()
  (set-cache :ssr)
  (set-response-status :not-found)
  (set-metadata *metadata*)
  (hsx
   (div :class "flex flex-col h-full items-center justify-center gap-6 py-20 text-center"
     (p :class "font-display text-[120px] sm:text-[160px] font-bold leading-none accent-text"
       "404")
     (div :class "flex flex-col gap-2"
       (h1 :class "font-display font-bold text-2xl tracking-tight"
         "Page not found")
       (p :class "text-sm text-muted"
         "お探しのページは削除されたか、URL が間違っている可能性があります。"))
     (a :href "/"
        :class (clsx "mt-4 inline-flex items-center gap-2 px-5 py-2.5 rounded-full"
                     "accent-gradient text-white font-display font-semibold text-sm"
                     "hover:shadow-glow hover:-translate-y-0.5 transition-all duration-200")
       (img :src "/assets/img/icon/arrow-left.svg"
            :class "size-4" :alt "" :aria-hidden "true")
       "Back to home"))))
