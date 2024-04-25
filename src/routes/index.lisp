(defpackage #:hp/routes/index
  (:use #:cl
        #:piccolo
        #:cl-interpol)
  (:import-from #:hp/view/*
                #:defasset
                #:render)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(named-readtables:in-readtable :interpol-syntax)

(defasset *me-img* :img "me.jpg")

(define-element page ()
  (div :class "h-full place-content-center"
    (div :class "flex justify-center gap-x-20"
      (div :class "flex justify-end"
        (img
          :src *me-img*
          :alt "avatar of paku"
          :class "w-full max-w-xs rounded-xl shadow-sm"))
      (div :class "flex flex-col justify-center gap-10"
        (h1 :class "text-4xl font-bold"
          "paku (skyizwhite)")
        (p :class "text-xl"
          "Web developer"
          (br)
          "Admin of"
          (a :target "_blank" :href "https://himagine.club" :class "text-indigo-500"
            "himagine.club"))
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
            (let ((email "'paku'+'@'+'skyizwhite.dev'"))
              (a
                :x-data t
                :x-text email
                :|:href| #?"'mailto:'+${email}"
                :class "text-indigo-500")))
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
              "@skyizwhite@himagine.club")))))))

(defun handle-get (params)
  (declare (ignore params))
  (render (page)))
