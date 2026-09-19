(defpackage #:website-tests/lib/likes
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/likes
                #:likes-key))
(in-package #:website-tests/lib/likes)

(deftest likes-key
  (testing "namespaces the blog id"
    (ok (string= "blog:abc123:likes" (likes-key "abc123")))))
