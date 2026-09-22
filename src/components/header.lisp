(defpackage #:website/components/header
  (:use #:cl
        #:hsx
        #:jingle
        #:website/components/icons)
  (:import-from #:website/helper
                #:draft-mode-p)
  (:export #:~header))
(in-package #:website/components/header)

(defparameter *pc-menu*
  '(("/about" "about")
    ("/works" "works")
    ("/blog" "blog")))

(defparameter *sp-menu*
  (cons '("/" "home") *pc-menu*))

(defun current-path-p (href)
  (string= href (request-uri *request*)))

(defcomp ~wordmark ()
  (hsx
   (a :href "/"
     :class "text-base font-extrabold tracking-tight text-fg hover:opacity-60"
     "skyizwhite")))

(defcomp ~draft-badge ()
  (hsx
   (span :class "flex items-center gap-2"
     (span :class "size-1.5 rounded-full bg-invert animate-pulse")
     (span :class "eyebrow" "Draft Mode"))))

(defcomp ~pc-nav ()
  (hsx
   (nav :class "hidden md:block"
     (ul :class "flex items-center gap-7"
       (loop
         :for (href label) :in *pc-menu* :collect
            (let ((active (current-path-p href)))
              (hsx
               (li
                 (a
                   :href href
                   :class (clsx "relative block py-1 text-sm font-bold tracking-tight"
                                (if active "text-fg" "text-subtle hover:text-fg"))
                   label
                   (span :class (clsx "absolute -bottom-0.5 left-0 h-px bg-invert"
                                      "transition-all duration-300 ease-ui"
                                      (if active "w-full" "w-0"))))))))))))

(defcomp ~mobile-drawer ()
  (hsx
   (div :class "md:hidden"
     (div
       :nm-bind "{
                   onclick: () => close(),
                   'class.opacity-100': () => open,
                   'class.opacity-0': () => !open,
                   'class.pointer-events-none': () => !open
                 }"
       :class (clsx "fixed inset-0 z-40 bg-ink-950/20"
                    "opacity-0 pointer-events-none transition-opacity duration-300"))
     (aside
       :nm-bind "{
                   'class.translate-y-0': () => open,
                   'class.visible': () => open,
                   'class.-translate-y-full': () => !open,
                   'class.invisible': () => !open
                 }"
       :class (clsx "fixed top-0 inset-x-0 z-50"
                    "bg-base border-b border-base shadow-pop"
                    "-translate-y-full invisible"
                    "transition-[translate,visibility] duration-400 ease-ui")
       (div :class "shell h-14 flex items-center justify-between"
         (span :class "eyebrow" "menu")
         (button
           :aria-label "Close menu"
           :type "button"
           :nm-bind "{ onclick: () => close() }"
           :class (clsx "-mr-2 inline-flex items-center justify-center size-10"
                        "text-subtle hover:text-fg cursor-pointer")
           (~icon-close :class "size-5")))
       (nav :class "shell pb-6"
         (ul :class "border-t border-base"
           (loop
             :for (href label) :in *sp-menu* :collect
                (let ((active (current-path-p href)))
                  (hsx
                   (li
                     (a :href href
                       :class "group row items-center justify-between gap-4 text-fg hover:text-subtle"
                       (span :class "text-2xl font-bold tracking-tighter"
                         label)
                       (and (not active)
                            (hsx
                             (~icon-arrow-right
                               :class "size-5 transition-transform group-hover:translate-x-1")))
                       (span :class (clsx "row-mark"
                                          (if active "w-full" "group-hover:w-full")))))))))
         (p :class "eyebrow pt-5"
           "skyizwhite.dev"))))))

(defcomp ~header ()
  (hsx
   (div
     :class "contents"
     :nm-data "{
                 open: false,
                 show() { this.open = true; document.body.style.overflow = 'hidden'; },
                 close() { this.open = false; document.body.style.overflow = ''; }
               }"
     :nm-bind "{
                 'onkeydown.window': (e) => { if (e.key === 'Escape') close() }
               }"
     (header :class "sticky top-0 z-30 w-full bg-ink-0/85 backdrop-blur-xl"
       (div :class "shell h-14 sm:h-16 flex items-center justify-between border-b border-base"
         (div :class "flex items-center gap-4"
           (~wordmark)
           (and (draft-mode-p) (~draft-badge)))
         (div :class "flex items-center"
           (~pc-nav)
           (button
             :aria-label "Open menu"
             :type "button"
             :nm-bind "{ onclick: () => show() }"
             :class (clsx "md:hidden -mr-2 inline-flex items-center justify-center size-10"
                          "text-subtle hover:text-fg cursor-pointer")
             (~icon-menu :class "size-5")))))
     (~mobile-drawer))))
