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

(defcomp ~pc-header ()
  (hsx
   (header :class "hidden md:flex justify-between py-4 border-b-1 top-0 bg-white"
     (p :class "z-20 text-3xl font-bold"
       (a :href "/" "skyizwhite"))
     (nav :class "flex items-end"
       (ul :class "flex gap-4 text-xl font-bold"
         (loop
           :for (href label) :in *pc-menu* :collect
              (if (string= href (request-uri *request*))
                  (hsx (li :class "text-pink-500" label))
                  (hsx (li (a :href href :class "hover:text-pink-500" label))))))))))

(defcomp ~sp-header ()
  (hsx
   (header
     :x-data "{ open: false }"
     :class "flex md:hidden justify-between py-2 border-b-1 top-0 bg-white"
     (p :class "z-20 text-2xl font-bold"
       (a :href "/" "skyizwhite"))
     (div :class "flex justify-end"
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
                      (hsx (li (a :href href :class "hover:text-pink-500" label))))))))))))

(defcomp ~header ()
  (hsx
   (<>
     (~pc-header)
     (~sp-header))))
