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

(defparameter *header-nm-data*
  "{
    open: false,
    show() { this.open = true; document.body.style.overflow = 'hidden'; },
    close() { this.open = false; document.body.style.overflow = ''; }
  }")

(defun icon-button-class ()
  (clsx "inline-flex items-center justify-center size-9 rounded-full"
        "border border-zinc-800/80"
        "bg-zinc-900/60"
        "hover:bg-zinc-900"
        "hover:border-zinc-700"
        "cursor-pointer transition-colors"))

(defcomp ~pc-nav ()
  (hsx
   (nav :class "hidden md:flex items-center"
     (ul :class "flex items-center gap-1 text-sm font-display font-semibold"
       (loop
         :for (href label) :in *pc-menu* :collect
            (let ((active (string= href (request-uri *request*))))
              (hsx
               (li
                 (a :href href
                   :class (clsx "relative px-3 py-2 rounded-full transition-colors"
                                (if active
                                    "text-fg"
                                    "text-muted hover:text-fg"))
                   label
                   (and active
                        (hsx (span :class "absolute inset-x-3 -bottom-px h-px bg-accent-500"))))))))))))

(defcomp ~mobile-drawer ()
  (hsx
   (div :class "md:hidden"
     ; backdrop
     (div
       :nm-bind "{ onclick: () => close(), 'class.opacity-100': () => open, 'class.opacity-0': () => !open, 'class.pointer-events-none': () => !open }"
       :class (clsx "fixed inset-0 z-40"
                    "bg-black/60"
                    "backdrop-blur-sm"
                    "opacity-0 pointer-events-none transition-opacity duration-200"))
     ; drawer panel
     (aside
       :nm-bind "{ 'class.translate-x-0': () => open, 'class.translate-x-full': () => !open }"
       :class (clsx "fixed top-0 right-0 bottom-0 z-50"
                    "w-[78%] max-w-xs"
                    "flex flex-col"
                    "bg-zinc-950"
                    "border-l border-zinc-800"
                    "shadow-2xl shadow-black/20"
                    "translate-x-full transition-transform duration-300 ease-out")
       (div :class "flex items-center justify-between h-14 px-4 border-b border-base"
         (span :class "text-xs uppercase tracking-[0.3em] text-subtle font-display"
           "menu")
         (button
           :aria-label "Close menu"
           :type "button"
           :nm-bind "{ onclick: () => close() }"
           :class (icon-button-class)
           (img :src "/assets/img/icon/close.svg"
             :class "size-4 icon-invert"
             :alt "" :aria-hidden "true")))
       (nav :class "flex-1 overflow-y-auto px-4 py-8"
         (ul :class "flex flex-col gap-1"
           (loop
             :for (href label) :in *sp-menu* :collect
                (let ((active (string= href (request-uri *request*))))
                  (hsx
                   (li
                     (a :href href
                       :nm-bind "{ onclick: () => close() }"
                       :class (clsx "group flex items-center justify-between"
                                      "px-3 py-3 rounded-xl"
                                      "font-display font-semibold text-2xl tracking-tight"
                                      "transition-colors"
                                      (if active
                                          "bg-zinc-900 text-fg"
                                          "text-muted hover:text-fg hover:bg-zinc-900/60"))
                         (span :class (if active "accent-text" "")
                           label)
                         (span :class (clsx "size-1.5 rounded-full transition-opacity"
                                            (if active
                                                "accent-gradient opacity-100"
                                                "bg-zinc-700 opacity-0 group-hover:opacity-100"))))))))))
         (div :class "px-4 py-4 border-t border-base text-[11px] text-subtle font-display tracking-widest uppercase"
           "skyizwhite.dev")))))

(defcomp ~header ()
  (hsx
   ;; `display: contents` wrapper owns the nomini scope without generating a
   ;; box, so the sticky header and the fixed drawer both resolve against the
   ;; viewport (the header's `backdrop-blur` would otherwise trap the drawer).
   (div
     :class "contents"
     :nm-data *header-nm-data*
     :nm-bind "{ 'onkeydown.window': (e) => { if (e.key === 'Escape') close() } }"
     (header
       :class (clsx "sticky top-0 z-30 w-full"
                    "bg-zinc-950/70"
                    "backdrop-blur-xl saturate-150"
                    "border-b border-zinc-800/60")
       (div :class "max-w-[760px] mx-auto px-4 sm:px-6 h-14 flex items-center justify-between"
         (a :href "/" :class "group"
           (span :class "font-display text-xl font-bold tracking-tight group-hover:accent-text"
             "skyizwhite"))
         (div :class "flex items-center gap-2"
           (~pc-nav)
           (button
             :aria-label "Open menu"
             :class (clsx "md:hidden" (icon-button-class))
             :type "button"
             :nm-bind "{ onclick: () => show() }"
             (img :src "/assets/img/icon/menu.svg"
               :class "size-4 icon-invert"
               :alt "" :aria-hidden "true")))))
     (~mobile-drawer))))
