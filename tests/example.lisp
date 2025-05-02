(defpackage #:website-tests/example
  (:use #:cl
        #:fiveam))
(in-package #:website-tests/example)

(def-suite example-test)
(in-suite example-test)

(test adder-test
  (is (= (+ 1 1) 2)))
