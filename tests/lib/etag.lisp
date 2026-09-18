(defpackage #:website-tests/lib/etag
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/cache
                #:*page-versions*
                #:revalidate-path)
  (:import-from #:website/lib/etag
                #:*swr-cache-control*
                #:*etag-middleware*
                #:current-etag
                #:opaque-tag
                #:if-none-match-p
                #:taggable-request-p
                #:taggable-response-p))
(in-package #:website-tests/lib/etag)

(defmacro with-website-env ((value) &body body)
  (let ((saved (gensym "SAVED")))
    `(let ((,saved (uiop:getenv "WEBSITE_ENV")))
       (setf (uiop:getenv "WEBSITE_ENV") ,value)
       (unwind-protect (progn ,@body)
         (setf (uiop:getenv "WEBSITE_ENV") (or ,saved ""))))))

(defun make-env (&key (method :get) (path "/") query if-none-match)
  (let ((headers (make-hash-table :test #'equal)))
    (when if-none-match
      (setf (gethash "if-none-match" headers) if-none-match))
    (list :request-method method
          :path-info path
          :query-string query
          :headers headers)))

(defun swr-response (&rest extra-headers)
  (list 200
        (append (list :content-type "text/html" :cache-control *swr-cache-control*)
                extra-headers)
        (list "body")))

(deftest current-etag
  (let ((*page-versions* (make-hash-table :test #'equal)))
    (testing "is a weak tag shared by paths at the same version"
      (ok (uiop:string-prefix-p "W/\"" (current-etag "/")))
      (ok (string= (current-etag "/") (current-etag "/about"))))
    (testing "changes only for the revalidated path"
      (let ((root (current-etag "/"))
            (about (current-etag "/about")))
        (revalidate-path "/about")
        (ok (string= root (current-etag "/")))
        (ok (string/= about (current-etag "/about")))))))

(deftest opaque-tag
  (testing "strips the weak prefix and surrounding whitespace"
    (ok (string= "\"a.1\"" (opaque-tag "W/\"a.1\"")))
    (ok (string= "\"a.1\"" (opaque-tag "\"a.1\"")))
    (ok (string= "\"a.1\"" (opaque-tag (format nil " ~cW/\"a.1\" " #\Tab))))))

(deftest if-none-match-p
  (let ((etag "W/\"b.3\""))
    (testing "matches the exact tag"
      (ok (if-none-match-p (make-env :if-none-match etag) etag)))
    (testing "compares weakly"
      (ok (if-none-match-p (make-env :if-none-match "\"b.3\"") etag)))
    (testing "matches any tag in a list"
      (ok (if-none-match-p (make-env :if-none-match "W/\"x\", W/\"b.3\"") etag))
      (ok (if-none-match-p (make-env :if-none-match (format nil "W/\"x\",~cW/\"b.3\"" #\Tab)) etag)))
    (testing "rejects other tags and a missing header"
      (ok (not (if-none-match-p (make-env :if-none-match "W/\"b.2\"") etag)))
      (ok (not (if-none-match-p (make-env :if-none-match "*") etag)))
      (ok (not (if-none-match-p (make-env) etag))))))

(deftest taggable-request-p
  (testing "accepts plain GET and HEAD page requests"
    (ok (taggable-request-p (make-env)))
    (ok (taggable-request-p (make-env :method :head :path "/blog/x")))
    (ok (taggable-request-p (make-env :path "/api-notes"))))
  (testing "rejects other methods and query strings"
    (ok (not (taggable-request-p (make-env :method :post))))
    (ok (not (taggable-request-p (make-env :query "draft-key=a")))))
  (testing "rejects the bypassed prefixes on a path boundary"
    (ok (not (taggable-request-p (make-env :path "/assets/style/dist.css"))))
    (ok (not (taggable-request-p (make-env :path "/actions/abc"))))
    (ok (not (taggable-request-p (make-env :path "/api"))))
    (ok (not (taggable-request-p (make-env :path "/api/revalidate"))))))

(deftest taggable-response-p
  (testing "accepts a 200 that opted into the SWR strategy"
    (ok (taggable-response-p (swr-response))))
  (testing "rejects other statuses, other cache policies and per-visitor responses"
    (ok (not (taggable-response-p (list 404 (list :cache-control *swr-cache-control*) nil))))
    (ok (not (taggable-response-p (list 200 (list :cache-control "private, no-store") nil))))
    (ok (not (taggable-response-p (list 200 (list :content-type "text/html") nil))))
    (ok (not (taggable-response-p (swr-response :set-cookie "a=b"))))))

(deftest etag-middleware
  (with-website-env ("test")
    (let* ((*page-versions* (make-hash-table :test #'equal))
           (calls 0)
           (app (funcall *etag-middleware*
                         (lambda (env)
                           (declare (ignore env))
                           (incf calls)
                           (swr-response))))
           (etag (current-etag "/")))
      (testing "tags a fresh response"
        (let ((res (funcall app (make-env))))
          (ok (= 200 (first res)))
          (ok (string= etag (getf (second res) :etag)))
          (ok (string= *swr-cache-control* (getf (second res) :cache-control)))))
      (testing "answers a matching If-None-Match with 304 without running the app"
        (let ((before calls)
              (res (funcall app (make-env :if-none-match etag))))
          (ok (= 304 (first res)))
          (ok (= before calls))
          (ok (string= etag (getf (second res) :etag)))
          (ok (string= *swr-cache-control* (getf (second res) :cache-control)))
          (ok (null (third res)))))
      (testing "renders again for a stale tag"
        (ok (= 200 (first (funcall app (make-env :if-none-match "W/\"0.0\""))))))
      (testing "invalidates only the revalidated path"
        (revalidate-path "/")
        (ok (= 200 (first (funcall app (make-env :if-none-match etag)))))
        (ok (= 304 (first (funcall app (make-env :if-none-match (current-etag "/"))))))
        (ok (= 304 (first (funcall app (make-env :path "/about" :if-none-match etag))))))
      (testing "leaves bypassed requests untouched"
        (ok (null (getf (second (funcall app (make-env :path "/assets/x.css"))) :etag)))
        (ok (null (getf (second (funcall app (make-env :query "x=1"))) :etag))))))
  (testing "is disabled in dev mode"
    (with-website-env ("dev")
      (let ((app (funcall *etag-middleware*
                          (lambda (env) (declare (ignore env)) (swr-response)))))
        (ok (null (getf (second (funcall app (make-env))) :etag)))
        (ok (= 200 (first (funcall app (make-env :if-none-match (current-etag "/"))))))))))
