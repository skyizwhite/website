(defpackage #:website-tests/example
  (:use #:cl
        #:rove))
(in-package #:website-tests/example)

(deftest example
  (testing "something..."
    (ok (= (+ 1 1) 2))))
