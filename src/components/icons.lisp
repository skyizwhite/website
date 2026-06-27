(defpackage #:website/components/icons
  (:use #:cl
        #:hsx)
  (:export #:~icon-activitypub
           #:~icon-arrow-left
           #:~icon-arrow-right
           #:~icon-briefcase
           #:~icon-close
           #:~icon-email
           #:~icon-github
           #:~icon-heart
           #:~icon-key
           #:~icon-matrix
           #:~icon-menu
           #:~icon-server
           #:~icon-spinner
           #:~icon-user))
(in-package #:website/components/icons)

(defcomp ~icon-activitypub (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24" :aria-hidden "true"
     (path :fill "currentColor"
       :d "M10.91 4.442L0 10.74v2.52l8.727-5.04v10.077l2.182 1.26zM6.545 12l-4.364 2.52l4.364 2.518zm6.545-2.52L17.455 12l-4.364 2.52zm0-5.038L24 10.74v2.52l-10.91 6.298v-2.52L21.819 12l-8.728-5.04z"))))

(defcomp ~icon-arrow-left (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24"
     :fill "none" :stroke "currentColor" :stroke-width "2"
     :stroke-linecap "round" :stroke-linejoin "round" :aria-hidden "true"
     (line :x1 "19" :y1 "12" :x2 "5" :y2 "12")
     (polyline :points "12 19 5 12 12 5"))))

(defcomp ~icon-arrow-right (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24"
     :fill "none" :stroke "currentColor" :stroke-width "2"
     :stroke-linecap "round" :stroke-linejoin "round" :aria-hidden "true"
     (line :x1 "5" :y1 "12" :x2 "19" :y2 "12")
     (polyline :points "12 5 19 12 12 19"))))

(defcomp ~icon-briefcase (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24"
     :fill "none" :stroke "currentColor" :stroke-width "2"
     :stroke-linecap "round" :stroke-linejoin "round" :aria-hidden "true"
     (rect :x "2" :y "7" :width "20" :height "14" :rx "2" :ry "2")
     (path :d "M16 21V5a2 2 0 0 0-2-2h-4a2 2 0 0 0-2 2v16"))))

(defcomp ~icon-close (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24" :aria-hidden "true"
     (g :fill "none" :fill-rule "evenodd"
       (path :d "m12.593 23.258l-.011.002l-.071.035l-.02.004l-.014-.004l-.071-.035q-.016-.005-.024.005l-.004.01l-.017.428l.005.02l.01.013l.104.074l.015.004l.012-.004l.104-.074l.012-.016l.004-.017l-.017-.427q-.004-.016-.017-.018m.265-.113l-.013.002l-.185.093l-.01.01l-.003.011l.018.43l.005.012l.008.007l.201.093q.019.005.029-.008l.004-.014l-.034-.614q-.005-.018-.02-.022m-.715.002a.02.02 0 0 0-.027.006l-.006.014l-.034.614q.001.018.017.024l.015-.002l.201-.093l.01-.008l.004-.011l.017-.43l-.003-.012l-.01-.01z")
       (path :fill "currentColor"
         :d "m12 13.414l5.657 5.657a1 1 0 0 0 1.414-1.414L13.414 12l5.657-5.657a1 1 0 0 0-1.414-1.414L12 10.586L6.343 4.929A1 1 0 0 0 4.93 6.343L10.586 12l-5.657 5.657a1 1 0 1 0 1.414 1.414z")))))

(defcomp ~icon-email (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24" :aria-hidden "true"
     (path :fill "currentColor"
       :d "M2 6a2 2 0 0 1 2-2h16a2 2 0 0 1 2 2v12a2 2 0 0 1-2 2H4a2 2 0 0 1-2-2zm3.519 0L12 11.671L18.481 6zM20 7.329l-7.341 6.424a1 1 0 0 1-1.318 0L4 7.329V18h16z"))))

(defcomp ~icon-github (&key class)
  (hsx
   (svg :class class :viewbox "0 0 16 16" :aria-hidden "true"
     (path :fill "currentColor"
       :d "M8 0c4.42 0 8 3.58 8 8a8.01 8.01 0 0 1-5.45 7.59c-.4.08-.55-.17-.55-.38c0-.27.01-1.13.01-2.2c0-.75-.25-1.23-.54-1.48c1.78-.2 3.65-.88 3.65-3.95c0-.88-.31-1.59-.82-2.15c.08-.2.36-1.02-.08-2.12c0 0-.67-.22-2.2.82c-.64-.18-1.32-.27-2-.27s-1.36.09-2 .27c-1.53-1.03-2.2-.82-2.2-.82c-.44 1.1-.16 1.92-.08 2.12c-.51.56-.82 1.28-.82 2.15c0 3.06 1.86 3.75 3.64 3.95c-.23.2-.44.55-.51 1.07c-.46.21-1.61.55-2.33-.66c-.15-.24-.6-.83-1.23-.82c-.67.01-.27.38.01.53c.34.19.73.9.82 1.13c.16.45.68 1.31 2.69.94c0 .67.01 1.3.01 1.49c0 .21-.15.45-.55.38A7.995 7.995 0 0 1 0 8c0-4.42 3.58-8 8-8"))))

(defcomp ~icon-heart (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24" :fill "#f43f74" :aria-hidden "true"
     (path :d "M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z"))))

(defcomp ~icon-key (&key class)
  (hsx
   (svg :class class :viewbox "0 0 16 16" :aria-hidden "true"
     (path :fill "currentColor"
       :d "M10.5 0a5.499 5.499 0 1 1-1.288 10.848l-.932.932a.75.75 0 0 1-.53.22H7v.75a.75.75 0 0 1-.22.53l-.5.5a.75.75 0 0 1-.53.22H5v.75a.75.75 0 0 1-.22.53l-.5.5a.75.75 0 0 1-.53.22h-2A1.75 1.75 0 0 1 0 14.25v-2c0-.199.079-.389.22-.53l4.932-4.932A5.5 5.5 0 0 1 10.5 0m-4 5.5c-.001.431.069.86.205 1.269a.75.75 0 0 1-.181.768L1.5 12.56v1.69c0 .138.112.25.25.25h1.69l.06-.06v-1.19a.75.75 0 0 1 .75-.75h1.19l.06-.06v-1.19a.75.75 0 0 1 .75-.75h1.19l1.023-1.025a.75.75 0 0 1 .768-.18A4 4 0 1 0 6.5 5.5M11 6a1 1 0 1 1 0-2a1 1 0 0 1 0 2"))))

(defcomp ~icon-matrix (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24" :aria-hidden "true"
     (path :fill "none" :stroke "currentColor"
       :stroke-linecap "round" :stroke-linejoin "round" :stroke-width "2"
       :d "M4 3H3v18h1m16 0h1V3h-1M7 9v6m5 0v-3.5a2.5 2.5 0 1 0-5 0v.5m10 3v-3.5a2.5 2.5 0 1 0-5 0v.5"))))

(defcomp ~icon-menu (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24"
     :fill "none" :stroke "currentColor" :stroke-width "2"
     :stroke-linecap "round" :stroke-linejoin "round" :aria-hidden "true"
     (line :x1 "4" :y1 "7" :x2 "20" :y2 "7")
     (line :x1 "4" :y1 "12" :x2 "20" :y2 "12")
     (line :x1 "4" :y1 "17" :x2 "20" :y2 "17"))))

(defcomp ~icon-server (&key class)
  (hsx
   (svg :class class :viewbox "0 0 16 16" :aria-hidden "true"
     (path :fill "currentColor"
       :d "M1.75 1h12.5c.966 0 1.75.784 1.75 1.75v4c0 .372-.116.717-.314 1c.198.283.314.628.314 1v4a1.75 1.75 0 0 1-1.75 1.75H1.75A1.75 1.75 0 0 1 0 12.75v-4c0-.358.109-.707.314-1a1.74 1.74 0 0 1-.314-1v-4C0 1.784.784 1 1.75 1M1.5 2.75v4c0 .138.112.25.25.25h12.5a.25.25 0 0 0 .25-.25v-4a.25.25 0 0 0-.25-.25H1.75a.25.25 0 0 0-.25.25m.25 5.75a.25.25 0 0 0-.25.25v4c0 .138.112.25.25.25h12.5a.25.25 0 0 0 .25-.25v-4a.25.25 0 0 0-.25-.25ZM7 4.75A.75.75 0 0 1 7.75 4h4.5a.75.75 0 0 1 0 1.5h-4.5A.75.75 0 0 1 7 4.75M7.75 10h4.5a.75.75 0 0 1 0 1.5h-4.5a.75.75 0 0 1 0-1.5M3 4.75A.75.75 0 0 1 3.75 4h.5a.75.75 0 0 1 0 1.5h-.5A.75.75 0 0 1 3 4.75M3.75 10h.5a.75.75 0 0 1 0 1.5h-.5a.75.75 0 0 1 0-1.5"))))

(defcomp ~icon-spinner (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24"
     :fill "none" :stroke "#f43f74" :stroke-width "2.5"
     :stroke-linecap "round" :aria-hidden "true"
     (path :d "M21 12a9 9 0 1 1-6.219-8.56"))))

(defcomp ~icon-user (&key class)
  (hsx
   (svg :class class :viewbox "0 0 24 24"
     :fill "none" :stroke "currentColor" :stroke-width "2"
     :stroke-linecap "round" :stroke-linejoin "round" :aria-hidden "true"
     (path :d "M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2")
     (circle :cx "12" :cy "7" :r "4"))))
