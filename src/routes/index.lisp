(defpackage #:hp/routes/index
  (:use #:cl
        #:hsx)
  (:export #:handle-get))
(in-package #:hp/routes/index)

(defparameter *links*
  '(("Keyoxide"       "https://keyoxide.org/f39d5b2c951d16732a5cd3528f0c1a22f26d7e62")
    ("GitHub"         "https://github.com/skyizwhite")
    ("Forgejo"        "https://code.skyizwhite.dev/paku")
    ("X"              "https://x.com/skyizwhite")
    ("Fediverse"      "https://himagine.club/@skyizwhite")
    ("Service Status" "https://status.skyizwhite.dev")))

(defcomp ~page ()
  (hsx
   (section :class "flex flex-col items-center justify-center h-full"
     (img :src "/img/me.webp" :alt "Profile Picture" :class "size-40 rounded rounded-full border shadow-lg")
     (div :class "flex flex-col items-center gap-2 py-6"
       (h1 :class "font-bold text-2xl"
         "Akira Tempaku")
       (p :class "text-xl"
         "Web developer"))
     (div :class "flex flex-col items-center text-pink-500"
       (loop
         :for (name url) :in *links*
         :collect (hsx (a :href url :target "_blank" :class "text-lg hover:underline"
                         name)))))))

(defun handle-get (params)
  (declare (ignore params))
  (~page))
