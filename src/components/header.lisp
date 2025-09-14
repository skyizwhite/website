(defpackage #:website/components/header
  (:use #:cl
        #:hsx
        #:jingle)
  (:export #:~header))
(in-package #:website/components/header)

(defparameter *pc-menu*
  '(("/about" "about")
    ("/works" "works")
    ("/blog" "blog")))

(defparameter *sp-menu*
  (cons '("/" "home") *pc-menu*))

(defcomp ~pc-nav ()
  (hsx
   (nav :class "hidden md:flex items-end"
     (ul :class "flex gap-4 text-xl font-bold"
       (loop
         :for (href label) :in *pc-menu* :collect
            (if (string= href (request-uri *request*))
                (hsx (li :class "text-pink-500" label))
                (hsx (li (a :href href :class "hover:text-pink-500" label)))))))))

(defcomp ~sp-nav ()
  (hsx
   (div :class "flex md:hidden justify-end" :x-data "{ open: false }"
     (button
       :aria-label "Open menu"
       :class "h-8 cursor-pointer"
       :type "button"
       :@click "open = true"
       (span :class "font-bold text-lg"
         "menu"))
     (nav
       :class "fixed flex flex-col z-10 top-0 right-0 p-2 w-full h-full bg-gray-200"
       :x-show "open"
       :x-transition t
       :|x-transition:enter.duration.200ms| t
       :|x-transition:leave.duration.200ms| t
       (div :class "flex justify-end"
         (button
           :aria-label "Close menu"
           :type "button"
           :@click "open = false"
           (img :class "size-8" :src "/assets/img/icon/close.svg")))
       (div :class "flex flex-col items-center pt-16 gap-16"
         (h2 :class "text-5xl font-bold"
           "Menu")
         (ul :class "flex flex-col h-fit gap-8 text-3xl font-bold"
           (loop
             :for (href label) :in *sp-menu* :collect
                (if (string= href (request-uri *request*))
                    (hsx (li :class "text-pink-500" label))
                    (hsx (li (a :href href :class "hover:text-pink-500" label)))))))))))

(defcomp ~header ()
  (hsx
   (header :class "flex justify-between py-2 md:py-4 border-b-1 top-0 bg-white"
     (a :href "/" :class "flex items-center gap-2 z-20"
       (img :src "/assets/img/logo.png" :class "h-7 md:h-9 aspect-auto")
       (span :class "text-2xl md:text-3xl font-bold"
         "skyizwhite"))
     (~pc-nav)
     (~sp-nav))))
