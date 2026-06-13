(defpackage #:website/components/error-page
  (:use #:cl
        #:hsx
        #:website/components/icons)
  (:export #:~error-page
           #:error-metadata))
(in-package #:website/components/error-page)

(defparameter *error-info*
  '((404 :title "Page not found"
     :description "The page you are looking for may have been deleted or the URL might be incorrect."
     :message "お探しのページは削除されたか、URL が間違っている可能性があります。")
    (500 :title "Something went wrong"
     :description "Something went wrong while loading this page. Please try again later."
     :message "問題が発生しました。しばらくしてから再度お試しください。"))
  "Per-status copy for the error page, keyed by HTTP status code.")

(defun error-metadata (status)
  (let ((info (cdr (assoc status *error-info*))))
    (list :title (getf info :title)
          :description (getf info :description)
          :error t)))

(defcomp ~error-page (&key status)
  (let ((info (cdr (assoc status *error-info*))))
    (hsx
     (div :class "flex flex-col h-full items-center justify-center gap-6 py-20 text-center"
       (p :class "font-display text-[120px] sm:text-[160px] font-bold leading-none accent-text"
         status)
       (div :class "flex flex-col gap-2"
         (h1 :class "font-display font-bold text-2xl tracking-tight"
           (getf info :title))
         (p :class "text-sm text-muted"
           (getf info :message)))
       (a :href "/"
         :class (clsx "mt-4 inline-flex items-center gap-2 px-5 py-2.5 rounded-full"
                      "accent-gradient text-white font-display font-semibold text-sm"
                      "hover:shadow-glow hover:-translate-y-0.5 transition-all duration-200")
         (~icon-arrow-left :class "size-4")
         "Back to home")))))
