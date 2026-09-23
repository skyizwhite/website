(defpackage #:website-tests/api/revalidate
  (:use #:cl
        #:rove)
  (:import-from #:website/api/revalidate
                #:payload-targets
                #:revalidate-targets)
  (:import-from #:website/lib/cache
                #:revalidate-tag
                #:revalidate-path
                #:page-version)
  ;; loaded for its fetchers: they are what the tags below have to name
  (:import-from #:website/lib/cms
                #:fetch-about #:fetch-works #:fetch-blog-list
                #:fetch-recent-blog-list #:fetch-blog-detail))
(in-package #:website-tests/api/revalidate)

;;; The webhook koya sends is this site's only invalidation trigger.
;;; REVALIDATE-TARGETS is the whole decision, kept free of the request so it can
;;; be read off a table here.

(defun targets (event model &optional (id "01J0"))
  (multiple-value-bind (tags paths status) (revalidate-targets event model id)
    (list status tags paths)))

(deftest draft-changes-nothing-published
  (ok (equal (targets "draft" "blog") '(:ignored () ()))
      "a draft save is ignored whatever it is a draft of")
  (ok (equal (targets "draft" "about") '(:ignored () ()))))

(deftest each-model-invalidates-its-own-pages
  (ok (equal (targets "publish" "about") '(:ok ("about") ("/about"))))
  (ok (equal (targets "publish" "works") '(:ok ("works") ("/works"))))
  (testing "a post also invalidates the index it appears in and the front page"
    (ok (equal (targets "publish" "blog" "01ARZ3NDEKTSV4RRFFQ69G5FAV")
               '(:ok ("blog") ("/blog/01ARZ3NDEKTSV4RRFFQ69G5FAV" "/blog" "/")))))
  (testing "every event but draft acts, so an unpublish clears the same pages"
    (ok (equal (targets "unpublish" "blog" "x") '(:ok ("blog") ("/blog/x" "/blog" "/"))))
    (ok (equal (targets "delete" "blog" "x") '(:ok ("blog") ("/blog/x" "/blog" "/"))))))

(deftest a-model-this-site-does-not-serve
  (ok (equal (targets "publish" "tag") '(:unknown () ())))
  (testing "a payload without the key the handler reads is unknown, not an error"
    ;; koya 0.3.0 and earlier called this key \"api\"; a stale server sending one
    ;; leaves MODEL nil, and that has to fall through rather than break
    (ok (equal (targets "publish" nil) '(:unknown () ())))))

;;; The mapping is only half of it: the tags have to be ones the site's own
;;; fetchers carry -- REVALIDATE-TAG signals on a tag no fetcher answers to,
;;; which in production is a 500 back to koya -- and the paths have to be the
;;; ones the pages are versioned by.

(deftest the-targets-are-ones-the-cache-knows
  (testing "every tag names a fetcher in website/lib/cms, so revalidate-tag does not signal"
    (dolist (model '("about" "works" "blog"))
      (multiple-value-bind (tags) (revalidate-targets "publish" model "x")
        (ok (equal (mapcar #'revalidate-tag tags) tags)
            (format nil "~a's tags are all registered" model)))))
  (testing "applying the paths moves the page versions the CDN reads"
    (multiple-value-bind (tags paths) (revalidate-targets "publish" "blog" "abc")
      (declare (ignore tags))
      (let ((before (mapcar #'page-version paths)))
        (mapc #'revalidate-path paths)
        (ok (every #'< before (mapcar #'page-version paths))
            "each of the post, the index and the front page is a version on")))))

;;; Which keys the payload is read by. This is the part that broke twice --
;;; koya called the model "api" before 0.4.0 -- and nothing above would notice,
;;; because it takes the model already extracted.

(defun payload (&key (event "publish") (model "blog") (id "01ARZ3NDEKTSV4RRFFQ69G5FAV"))
  "A koya webhook body as lack hands it over: an alist keyed by strings."
  (list (cons "space" "website")
        (cons "model" model)
        (cons "id" id)
        (cons "event" event)
        (cons "contents" (list (list "old") (list "new" (cons "title" "Hi"))))))

(defun from-payload (&rest args)
  (multiple-value-bind (tags paths status event model id) (apply #'payload-targets (list (apply #'payload args)))
    (list status tags paths event model id)))

(deftest the-payload-keys-koya-sends
  (testing "the model is read from \"model\", the event from \"event\", the id from \"id\""
    (ok (equal (from-payload)
               '(:ok ("blog") ("/blog/01ARZ3NDEKTSV4RRFFQ69G5FAV" "/blog" "/")
                 "publish" "blog" "01ARZ3NDEKTSV4RRFFQ69G5FAV"))))
  (testing "a draft save is read as one"
    (ok (equal (first (from-payload :event "draft")) :ignored)))
  (testing "koya 0.3.0's payload, which named the model \"api\", no longer resolves"
    (let ((stale (list (cons "service" "website") (cons "api" "blog")
                       (cons "id" "x") (cons "event" "publish"))))
      (ok (equal (nth-value 2 (payload-targets stale)) :unknown)
          "it falls through to 400 rather than revalidating nothing silently"))))
