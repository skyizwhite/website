(defpackage #:website-tests/lib/liked-posts
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/liked-posts
                #:parse-liked-ids
                #:serialize-liked-ids
                #:liked-id-p
                #:add-liked-id))
(in-package #:website-tests/lib/liked-posts)

(deftest parse-liked-ids
  (testing "empty input yields no ids"
    (ok (null (parse-liked-ids nil)))
    (ok (null (parse-liked-ids ""))))
  (testing "splits a comma-separated value"
    (ok (equal '("a") (parse-liked-ids "a")))
    (ok (equal '("a" "b" "c") (parse-liked-ids "a,b,c"))))
  (testing "drops empty segments"
    (ok (equal '("a" "b") (parse-liked-ids "a,,b")))))

(deftest serialize-liked-ids
  (testing "joins ids with commas"
    (ok (string= "" (serialize-liked-ids nil)))
    (ok (string= "a" (serialize-liked-ids '("a"))))
    (ok (string= "a,b,c" (serialize-liked-ids '("a" "b" "c")))))
  (testing "round-trips with parse-liked-ids"
    (let ((ids '("p1" "p2" "p3")))
      (ok (equal ids (parse-liked-ids (serialize-liked-ids ids)))))))

(deftest liked-id-p
  (testing "membership by string equality"
    (ok (liked-id-p "a" '("a" "b")))
    (ok (not (liked-id-p "x" '("a" "b"))))
    (ok (not (liked-id-p "a" nil)))))

(deftest add-liked-id
  (testing "appends a new id"
    (ok (equal '("a") (add-liked-id "a" nil)))
    (ok (equal '("a" "b" "c") (add-liked-id "c" '("a" "b")))))
  (testing "is idempotent for an existing id"
    (ok (equal '("a" "b") (add-liked-id "a" '("a" "b"))))))
