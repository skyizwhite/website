(defpackage #:hp/components/layout
  (:use #:cl
        #:piccolo
        #:cl-interpol)
  (:import-from #:hp/config/asset
                #:*hx-ext*)
  (:import-from #:hp/view/asset
                #:defasset)
  (:export #:layout))
(in-package #:hp/components/layout)

(named-readtables:in-readtable :interpol-syntax)

(defparameter *header-nav-items*
  '((:href "/"        :label "Home")
    (:href "/about"   :label "About")
    (:href "/work"    :label "Work")))

(define-element header-nav-item (href label)
  (li
    :class "px-4 rounded-full"
    :|:class| #?"isCurrentPath('${href}')
                 && 'font-bold bg-indigo-200 pointer-events-none shadow-sm'"
    (a :href href
      label)))

(define-element layout-header ()
  (header :class "px-10 py-6 flex justify-between"
    (h1 :class "font-bold text-xl"
      "skyizwhite.dev")
    (nav
      :x-data "{
        currentPath: window.location.pathname,
        isCurrentPath(path) {
          return this.currentPath === path
        }
      }"
      :hx-boost "true"
      (ul :class "h-full flex items-center gap-6 text-lg"
        (mapcar (lambda (item) (header-nav-item item))
                *header-nav-items*)))))

(define-element layout ()
  (body
    :hx-ext *hx-ext*
    :class "h-[100svh] flex flex-col bg-neutral-200"
    (layout-header)
    (main :class "flex-1"
      children)
    ; footer
    (footer)))
