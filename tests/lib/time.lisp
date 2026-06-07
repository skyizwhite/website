(defpackage #:website-tests/lib/time
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/time
                #:datetime
                #:jp-datetime))
(in-package #:website-tests/lib/time)

;; The app pins local-time to Asia/Tokyo, so a UTC timestamp is rendered
;; shifted by +9 hours.

(deftest datetime
  (testing "formats an ISO timestamp as zero-padded JST"
    (ok (string= "2025-01-01 09:00"
                 (datetime "2025-01-01T00:00:00.000Z")))
    (ok (string= "2025-09-15 10:24"
                 (datetime "2025-09-15T01:24:40.000Z")))))

(deftest jp-datetime
  (testing "formats an ISO timestamp with Japanese units in JST"
    (ok (string= "2025年1月1日 9時0分"
                 (jp-datetime "2025-01-01T00:00:00.000Z")))))
