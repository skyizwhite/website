(defpackage #:website/pages/index
  (:use #:cl
        #:hsx
        #:access
        #:jingle
        #:website/helper)
  (:export #:@get
           #:@head))
(in-package #:website/pages/index)

(defparameter *links*
  '(("Keyoxide"
     "https://keyoxide.org/f39d5b2c951d16732a5cd3528f0c1a22f26d7e62"
     "/assets/img/icon/key.svg")
    ("GitHub"
     "https://github.com/skyizwhite"
     "/assets/img/icon/github.svg")
    ("Email"
     "mailto:paku@skyizwhite.dev"
     "/assets/img/icon/email.svg")
    ("ActivityPub"
     "https://himagine.club/@skyizwhite"
     "/assets/img/icon/activitypub.svg")
    ("Signal"
     "https://signal.me/#eu/DuMA5nfb3EhFlp-6j4vBgtBIAUIcaF4Td2g3mopS7ZIA3VmmRrdLC5GoEgo8W446"
     "/assets/img/icon/signal.svg")
    ("Matrix"
     "https://matrix.to/#/@paku:skyizwhite.dev"
     "/assets/img/icon/matrix.svg")
    ("Notes"
     "https://note.skyizwhite.dev/share/fhZYyHoXV7cv"
     "/assets/img/icon/note.svg")
    ("Status"
     "https://status.skyizwhite.dev"
     "/assets/img/icon/server.svg")))

(defun @get (params)
  (declare (ignore params))
  (set-cache :sg)
  (hsx
   (div :class "flex flex-col items-center justify-center h-full"
     (div :class "md:flex md:gap-12 md:items-center"
       (img 
         :src "/assets/img/avatar.webp"
         :alt "avatar" :class "size-40 rounded-xl shadow-sm")
       (div :class "flex flex-col items-center py-6"
         (h1 :class "font-bold text-2xl text-center"
           "Akira Tempaku")))
     (div :class "grid grid-cols-2 gap-x-4 md:gap-x-12 gap-y-4 md:mt-12"
       (loop
         :for (name url icon-url) :in *links*
         :for i :from 0
         :collect
            (let ((icon (hsx (img
                               :src icon-url :alt ""
                               :class "size-6" :aria-hidden "true"))))
              (hsx (a
                     :href url :target "_blank" :rel "me"
                     :class (clsx "flex items-center gap-2 text-lg hover:text-pink-500"
                                  (and (evenp i) "justify-end"))
                     (and (oddp i) icon)
                     (span name)
                     (and (evenp i) icon)))))))))

; for health check
(defun @head (params)
  (declare (ignore params)))
