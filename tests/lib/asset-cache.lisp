(defpackage #:website-tests/lib/asset-cache
  (:use #:cl
        #:rove)
  (:import-from #:website/lib/etag
                #:*revalidate-cache-control*)
  (:import-from #:website/lib/asset-cache
                #:*immutable-cache-control*
                #:*asset-cache-middleware*
                #:versioned-path-p))
(in-package #:website-tests/lib/asset-cache)

(defun make-env (path &optional query)
  (list :request-method :get
        :path-info path
        :query-string query
        :headers (make-hash-table :test #'equal)))

(deftest versioned-path-p
  (testing "accepts a version query and content-hashed font files"
    (ok (versioned-path-p "/assets/style/dist.css" "v=1a2b3c4d"))
    (ok (versioned-path-p "/assets/fonts/LINESeedJP-Bold.119.3bf1726f.woff2" nil))
    (ok (versioned-path-p "/assets/style/fonts-a79af004.css" nil)))
  (testing "rejects bare asset paths"
    (ok (not (versioned-path-p "/assets/style/dist.css" nil)))
    (ok (not (versioned-path-p "/assets/img/og.jpg" "")))
    (ok (not (versioned-path-p "/assets/img/og.jpg" "x=1")))))

(deftest asset-cache-middleware
  (let* ((status 200)
         (literal '(404 (:content-type "text/plain") ("Not Found")))
         (app (funcall *asset-cache-middleware*
                       (lambda (env)
                         (setf (getf env :path-info) "/img/x")
                         (case status
                           (200 (list 200 (list :content-type "text/css") (list "body")))
                           (304 (list 304 nil nil))
                           (t literal))))))
    (testing "marks versioned assets immutable"
      (let ((res (funcall app (make-env "/assets/style/dist.css" "v=1a2b3c4d"))))
        (ok (string= *immutable-cache-control* (getf (second res) :cache-control)))
        (ok (string= "text/css" (getf (second res) :content-type)))))
    (testing "makes bare assets revalidate"
      (ok (string= *revalidate-cache-control*
                   (getf (second (funcall app (make-env "/assets/img/og.jpg"))) :cache-control))))
    (testing "leaves non-asset responses alone"
      (ok (null (getf (second (funcall app (make-env "/blog"))) :cache-control))))
    (testing "carries the policy on 304"
      (setf status 304)
      (let ((res (funcall app (make-env "/assets/img/og.jpg"))))
        (ok (= 304 (first res)))
        (ok (string= *revalidate-cache-control* (getf (second res) :cache-control)))))
    (testing "leaves other statuses untouched"
      (setf status 404)
      (let ((res (funcall app (make-env "/assets/img/missing.png" "v=1a2b3c4d"))))
        (ok (eq res literal))
        (ok (null (getf (second res) :cache-control)))))))
