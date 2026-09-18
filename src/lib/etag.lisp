(defpackage #:website/lib/etag
  (:use #:cl)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:export #:*swr-cache-control*
           #:bump-content-version
           #:*etag-middleware*))
(in-package #:website/lib/etag)

(defparameter *swr-cache-control*
  "public, max-age=0, stale-while-revalidate=604800, stale-if-error=604800")

(defparameter *build-id* (get-universal-time))

(defparameter *content-version* 0)

(defun bump-content-version ()
  (incf *content-version*))

(defun current-etag ()
  (format nil "W/\"~a.~a\"" *build-id* *content-version*))

(defparameter *bypass-prefixes* '("/assets" "/actions" "/api"))

(defun under-prefix-p (path prefix)
  (or (string= path prefix)
      (uiop:string-prefix-p (concatenate 'string prefix "/") path)))

(defun taggable-request-p (env)
  (let ((path (getf env :path-info)))
    (and (member (getf env :request-method) '(:get :head))
         (uiop:emptyp (getf env :query-string))
         (notany (lambda (prefix) (under-prefix-p path prefix))
                 *bypass-prefixes*))))

(defun taggable-response-p (res)
  (let ((headers (second res)))
    (and (= (first res) 200)
         (equal (getf headers :cache-control) *swr-cache-control*)
         (null (getf headers :set-cookie)))))

(defun opaque-tag (etag)
  (let ((etag (string-trim '(#\Space #\Tab) etag)))
    (if (uiop:string-prefix-p "W/" etag)
        (subseq etag 2)
        etag)))

(defun if-none-match-p (env etag)
  (let ((header (gethash "if-none-match" (getf env :headers))))
    (and header
         (member (opaque-tag etag)
                 (mapcar #'opaque-tag (uiop:split-string header :separator ","))
                 :test #'string=))))

(defparameter *etag-middleware*
  (lambda (app)
    (lambda (env)
      (if (or (dev-mode-p)
              (not (taggable-request-p env)))
          (funcall app env)
          (let ((etag (current-etag)))
            (if (if-none-match-p env etag)
                `(304 (:etag ,etag :cache-control ,*swr-cache-control*) nil)
                (let ((res (funcall app env)))
                  (when (taggable-response-p res)
                    (setf (getf (second res) :etag) etag))
                  res)))))))
