(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:access
        #:jingle
        #:website/helper)
  (:import-from #:website/lib/cms
                #:get-about)
  (:export #:handle-get
           #:handle-head))
(in-package #:website/pages/index)

(defparameter *links*
  '(("Keyoxide"
     "https://keyoxide.org/f39d5b2c951d16732a5cd3528f0c1a22f26d7e62"
     "/assets/img/icon/key.svg")
    ("Email"
     "mailto:paku@skyizwhite.dev"
     "/assets/img/icon/email.svg")
    ("Fediverse"
     "https://himagine.club/@skyizwhite"
     "/assets/img/icon/fediverse.svg")
    ("Matrix"
     "https://matrix.to/#/@paku:matrix.skyizwhite.dev"
     "/assets/img/icon/matrix.svg")
    ("GitHub"
     "https://github.com/skyizwhite"
     "/assets/img/icon/github.svg")
    ("Forgejo"
     "https://code.skyizwhite.dev/paku"
     "/assets/img/icon/forgejo.svg")
    ("Notes"
     "https://note.skyizwhite.dev/share/fhZYyHoXV7cv"
     "/assets/img/icon/note.svg")
    ("Status"
     "https://status.skyizwhite.dev"
     "/assets/img/icon/server.svg")))

(defun handle-get (params)
  (declare (ignore params))
  (set-cache :sg)
  (hsx
   (div :class "flex flex-col items-center justify-center h-full"
     (div :class "md:flex md:gap-12 md:items-center"
       (img 
         :src "/assets/img/avatar.webp"
         :alt "avatar" :class "size-40 rounded-xl shadow-sm")
       (div :class "flex flex-col items-center gap-2 py-6"
         (h1 :class "font-bold text-2xl text-center"
           "Akira Tempaku")
         (p :class "text-xl"
           "Software Engineer")))
     (div :class "grid grid-cols-2 gap-4 md:mt-12"
       (loop
         :for (name url icon) :in *links*
         :collect (hsx (a 
                         :href url 
                         :target "_blank" 
                         :class "flex items-center gap-2 text-lg hover:text-pink-500"
                         :rel "me"
                         (img :src icon :alt name :class "size-4")
                         (span name))))))))

; for health check
(defun handle-head (params)
  (declare (ignore params)))
