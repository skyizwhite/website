(defpackage #:website/components/error-page
  (:use #:cl
        #:hsx)
  (:import-from #:website/components/arrow-link
                #:~arrow-link)
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
     (div :class "py-2 sm:py-16"
       (p :class "display text-[clamp(5rem,22vw,11rem)]"
         status)
       (div :class "mt-6 pt-6 sm:mt-8 sm:pt-8 border-t border-base"
         (h1 :class "headline text-3xl sm:text-4xl"
           (getf info :title))
         (p :class "mt-4 sm:mt-5 text-base text-muted"
           (getf info :message))
         (div :class "mt-8 sm:mt-10"
           (~arrow-link :href "/" :direction :back "Back to home")))))))
