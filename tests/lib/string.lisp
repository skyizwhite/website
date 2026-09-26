(defpackage #:website-tests/lib/string
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/string
                #:squish))
(in-package #:website-tests/lib/string)

(deftest squish
  (testing "collapses runs of whitespace into one space and trims both ends"
    (ok (string= "{ open: false, show() { this.open = true } }"
                 (squish (format nil "{~%    open: false,~%~C show() { this.open = true }~%  }  "
                                 #\Tab)))))
  (testing "leaves a single-line string unchanged"
    (ok (string= "{ phase: 'init' }" (squish "{ phase: 'init' }"))))
  (testing "returns an empty string for whitespace only"
    (ok (string= "" (squish (format nil "  ~%  "))))))
