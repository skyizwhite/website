(defpackage #:website-tests/lib/cache
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/cache
                #:*page-versions*
                #:deffetcher
                #:revalidate-tag
                #:revalidate-path
                #:page-version))
(in-package #:website-tests/lib/cache)

(defvar *alpha-calls* 0)
(defvar *beta-calls* 0)

(deffetcher fetch-alpha (x) ("alpha" "shared")
  (incf *alpha-calls*)
  (* x 10))

(deffetcher fetch-beta () ("beta" "shared")
  (incf *beta-calls*)
  :beta)

(defun reset-fetchers ()
  (revalidate-tag "shared")
  (setf *alpha-calls* 0
        *beta-calls* 0))

(deftest deffetcher
  (testing "memoizes like defcached"
    (reset-fetchers)
    (ok (= 10 (fetch-alpha 1)))
    (ok (= 10 (fetch-alpha 1)))
    (ok (= 1 *alpha-calls*))))

(deftest revalidate-tag
  (testing "clears every fetcher carrying the tag and nothing else"
    (reset-fetchers)
    (fetch-alpha 1)
    (fetch-beta)
    (revalidate-tag "alpha")
    (fetch-alpha 1)
    (fetch-beta)
    (ok (= 2 *alpha-calls*))
    (ok (= 1 *beta-calls*)))
  (testing "a tag shared by several fetchers clears all of them"
    (reset-fetchers)
    (fetch-alpha 1)
    (fetch-beta)
    (revalidate-tag "shared")
    (fetch-alpha 1)
    (fetch-beta)
    (ok (= 2 *alpha-calls*))
    (ok (= 2 *beta-calls*)))
  (testing "an unknown tag is a programming error"
    (ok (signals (revalidate-tag "nope") 'error))))

(deftest revalidate-path
  (let ((*page-versions* (make-hash-table :test #'equal)))
    (testing "unvisited paths start at version 0"
      (ok (= 0 (page-version "/blog"))))
    (testing "increments only the given path"
      (revalidate-path "/blog")
      (revalidate-path "/blog")
      (ok (= 2 (page-version "/blog")))
      (ok (= 0 (page-version "/"))))))
