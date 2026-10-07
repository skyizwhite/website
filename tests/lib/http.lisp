(defpackage #:website-tests/lib/http
  (:use #:cl
        #:rove)
  (:import-from #:ningle
                #:*request*
                #:*response*)
  (:import-from #:lack/request
                #:make-request)
  (:import-from #:lack/response
                #:make-response
                #:response-headers
                #:response-status)
  (:import-from #:website/lib/http
                #:set-response-header
                #:set-response-status
                #:get-request-header
                #:with-request-params))
(in-package #:website-tests/lib/http)

(defun make-env (headers)
  (let ((table (make-hash-table :test #'equal)))
    (loop :for (name . value) :in headers
          :do (setf (gethash name table) value))
    (list :request-method :get
          :path-info "/"
          :query-string nil
          :headers table)))

(deftest set-response-header
  (let ((*response* (make-response 200 () ())))
    (testing "appends the header to the response"
      (set-response-header :cache-control "private, no-store")
      (ok (equal '(:cache-control "private, no-store") (response-headers *response*))))
    (testing "keeps a header set before"
      (set-response-header :link "</a.css>; rel=preload")
      (ok (equal '(:cache-control "private, no-store" :link "</a.css>; rel=preload")
                 (response-headers *response*))))))

(deftest set-response-status
  (let ((*response* (make-response 200 () ())))
    (set-response-status 404)
    (ok (= 404 (response-status *response*)))))

(deftest get-request-header
  (let ((*request* (make-request (make-env '(("x-koya-webhook-key" . "secret, other"))))))
    (testing "returns the value as it was sent"
      (ok (equal "secret, other" (get-request-header "x-koya-webhook-key"))))
    (testing "matches the name case-insensitively"
      (ok (equal "secret, other" (get-request-header "X-KOYA-WEBHOOK-KEY"))))
    (testing "returns nil for a header that was not sent"
      (ok (null (get-request-header "nm-request"))))))

(deftest with-request-params
  (let ((params '((:blog-id . "abc") ("draft-key" . "k"))))
    (testing "binds each name to its param"
      (with-request-params ((blog-id :blog-id nil)
                            (draft-key "draft-key" nil)) params
        (ok (equal "abc" blog-id))
        (ok (equal "k" draft-key))))
    (testing "falls back to the default when the param is missing"
      (with-request-params ((page "page" "1")) params
        (ok (equal "1" page))))))
