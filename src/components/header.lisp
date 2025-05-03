(defpackage #:website/components/header
  (:use #:cl
        #:hsx)
  (:import-from #:jingle
                #:request-uri)
  (:export #:~header))
(in-package #:website/components/header)

(defparameter *nav-menu*
  '(("/bio" "bio")
    ("/work" "work")
    ("/blog" "blog")))

(defcomp ~pc-header ()
  (hsx
   (nav :class "hidden md:flex items-end"
     (ul :preload "mouseover" :class "flex gap-4 text-xl font-medium"
       (loop
         :for (href label) :in *nav-menu* :collect
            (if (search href (request-uri jingle:*request*))
                (hsx (li :class "text-pink-500"
                       label))
                (hsx (li (a :href href :class "hover:text-pink-500"
                           label)))))))))

(defcomp ~sp-header ()
  (hsx
   (div :class "block md:hidden" :x-data "{ open: false }"
     (button
       :class "z-20 size-8 flex flex-col justify-center cursor-pointer relative"
       :type "button"
       :@click "open = !open"
       (div :class "grid justify-items-center gap-1.5"
         (span
           :class "h-1 w-8 rounded-full bg-black transition"
           :|:class| "open && 'rotate-45 translate-y-2.5'")
         (span
           :class "h-1 w-8 rounded-full bg-black transition"
           :|:class| "open && 'scale-x-0'")
         (span 
           :class "h-1 w-8 rounded-full bg-black"
           :|:class| "open && '-rotate-45 -translate-y-2.5'")))
     (nav
       :class (<>
                "fixed flex flex-col items-center justify-center "
                "z-10 top-0 right-0 w-full h-full gap-16 bg-gray-200")
       :x-show "open"
       :|x-transition:enter| "transition ease-out duration-400"
       :|x-transition:enter-start| "translate-x-full"
       :|x-transition:enter-end| "translate-x-0"
       :|x-transition:leave| "transition ease-in duration-400"
       :|x-transition:leave-start| "translate-x-0"
       :|x-transition:leave-end| "translate-x-full"
       (h2 :class "text-5xl font-bold"
         "Menu")
       (ul 
         :preload "mousedown"
         :class "flex flex-col h-fit gap-8 text-3xl font-medium"
         (loop
           :for (href label) :in *nav-menu* :collect
              (if (search href (request-uri jingle:*request*))
                  (hsx (li :class "text-pink-500"
                         label))
                  (hsx (li (a 
                             :href href
                             :class "hover:text-pink-500"
                             :@click "open = false"
                             label))))))))))

(defcomp ~header ()
  (hsx
   (header :class "flex justify-between py-2 md:py-4 border-b-1 top-0 bg-white"
     (h1 :class "z-20 text-2xl md:text-3xl font-bold"
       (a :href "/"
         "skyizwhite"))
     (~pc-header)
     (~sp-header))))
