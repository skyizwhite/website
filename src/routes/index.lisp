(uiop:define-package #:hp/routes/index
  (:use #:cl)
  (:mix #:parenscript
        #:paren6
        #:hsx)
  (:import-from #:hp/view/*
                #:defasset
                #:response)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(defasset *me-img* :img "me.jpg")

(defcomp page ()
  (hsx
   (div :class "h-full place-content-center"
     (div :class "flex justify-center gap-x-20"
       (div :class "flex justify-end"
         (img
           :src *me-img*
           :alt "avatar of paku"
           :class "w-full max-w-xs rounded-xl shadow-sm"))
       (div :class "flex flex-col justify-center gap-10"
         (h1 :class "text-4xl font-bold"
           "paku")
         (p :class "text-xl"
           "Web developer")
         (ul
           (li
             (span "GitHub:")
             (a
               :target "_blank"
               :href "https://github.com/skyizwhite"
               :class "text-indigo-500"
               "@skyizwhite"))
           (li
             (span "Email: ")
             (a
               :x-data (ps (create6
                            (email (chain (list6 "paku" "skyizwhite.dev")
                                          (join "@")))))
               :x-text (ps email)
               :|:href| (ps (chain (list6 "mailto:" email) (join "")))
               :|:class| "'text-indigo-500'"
               "(Please enable Javascript to show.)"))
           (li
             (span "Fediverse(main): ")
             (a
               :rel "me"
               :target "_blank" 
               :href "https://post.skyizwhite.dev/@paku"
               :class "text-indigo-500"
               "@paku@post.skyizwhite.dev"))
           (li
             (span "Fediverse(sub): ")
             (a
               :rel "me"
               :target "_blank"
               :href "https://himagine.club/@skyizwhite"
               :class "text-indigo-500"
               "@skyizwhite@himagine.club"))))))))

(defun handle-get (params)
  (declare (ignore params))
  (response (page)))
