(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:md5
                #:md5sum-file)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/lib/etag
                #:*swr-cache-control*
                #:*revalidate-cache-control*)
  (:import-from #:website/components/error-page
                #:~error-page
                #:error-metadata)
  (:export #:set-metadata
           #:set-cache
           #:asset-path
           #:*fonts-css*
           #:preloads
           #:preload-link
           #:with-nm-request
           #:error-action
           #:error-page))
(in-package #:website/helper)

(defparameter *asset-versions* (make-hash-table :test #'equal :synchronized t))

(defun asset-version (path)
  (let ((file (probe-file (format nil "assets/~a" path))))
    (when file
      (let ((stamp (file-write-date file))
            (cached (gethash path *asset-versions*)))
        (if (eql stamp (car cached))
            (cdr cached)
            (let ((version (format nil "~(~{~2,'0x~}~)"
                                   (coerce (subseq (md5sum-file file) 0 4) 'list))))
              (setf (gethash path *asset-versions*) (cons stamp version))
              version))))))

(defun asset-path (path &key (bust t))
  (format nil "/assets/~a~@[?v=~a~]" path (and bust (asset-version path))))

(defun find-asset (dir glob)
  (let ((file (first (directory (format nil "assets/~a/~a" dir glob)))))
    (and file (format nil "~a/~a.~a" dir (pathname-name file) (pathname-type file)))))

(defparameter *fonts-css* (find-asset "style" "fonts-*.css"))

(defparameter *preload-fonts*
  (let ((file (probe-file "assets/fonts/preload.txt")))
    (and file (remove-if #'uiop:emptyp (uiop:read-file-lines file)))))

(defun preloads ()
  (append (list (cons (asset-path "style/dist.css") "style"))
          (and *fonts-css*
               (list (cons (asset-path *fonts-css* :bust nil) "style")))
          (loop
            :for url :in *preload-fonts*
            :collect (cons url "font"))))

(defun preload-link ()
  (format nil "~{~a~^, ~}"
          (loop
            :for (url . as) :in (preloads)
            :collect (format nil "<~a>; rel=preload; as=~a~:[~;; crossorigin~]"
                             url as (string= as "font")))))

(defun set-metadata (metadata)
  (setf (context :metadata) metadata))

(defun set-cache (strategy)
  (cond ((dev-mode-p)
         (set-response-header :cache-control "private, no-store, must-revalidate"))
        ((eq strategy :ssr)
         (set-response-header :cache-control *revalidate-cache-control*))
        ((eq strategy :swr)
         (set-response-header :cache-control *swr-cache-control*))))

(defmacro with-nm-request (&body body)
  `(cond ((get-request-header "nm-request")
          ,@body)
         (t
          (set-response-status 400)
          nil)))

(defun error-action (status &optional body)
  (set-response-status status)
  body)

(defun error-page (&optional (status 500))
  (set-cache :ssr)
  (set-response-status status)
  (set-metadata (error-metadata status))
  (~error-page :status status))
