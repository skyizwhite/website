(defpackage #:website-tests/components/metadata
  (:use #:cl
        #:rove)
  (:import-from #:website/components/metadata
                #:complete-metadata))
(in-package #:website-tests/components/metadata)

(deftest complete-metadata
  (testing "fills in defaults when nothing is supplied"
    (let ((result (complete-metadata nil)))
      (ok (string= "skyizwhite" (getf result :title)))
      (ok (string= "The personal website of Akira Tempaku (paku)"
                   (getf result :description)))
      (ok (null (getf result :canonical)))
      (ok (string= "website" (getf result :type)))
      (ok (null (getf result :error)))
      (let ((image (getf result :image)))
        ;; The url is absolute and built from WEBSITE_URL, so only assert its
        ;; asset suffix and the fixed dimensions.
        (ok (uiop:string-suffix-p (getf image :url) "/assets/img/og.jpg"))
        (ok (eql 1024 (getf image :height)))
        (ok (eql 1024 (getf image :width))))))

  (testing "renders the title template around a supplied title"
    (ok (string= "Blog - skyizwhite"
                 (getf (complete-metadata '(:title "Blog")) :title))))

  (testing "an explicit value overrides its default"
    (let ((result (complete-metadata '(:description "custom"
                                       :canonical "/foo"
                                       :type "article"
                                       :error t))))
      (ok (string= "custom" (getf result :description)))
      (ok (string= "/foo" (getf result :canonical)))
      (ok (string= "article" (getf result :type)))
      (ok (eq t (getf result :error)))))

  (testing "keys outside the default set are dropped"
    (ok (eq :missing (getf (complete-metadata '(:bogus "x")) :bogus :missing)))))
