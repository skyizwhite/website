(uiop:define-package #:website/helper
  (:use #:cl
        #:jingle)
  (:import-from #:website/lib/env
                #:dev-mode-p)
  (:import-from #:website/lib/etag
                #:*swr-cache-control*)
  (:import-from #:website/components/error-page
                #:~error-page
                #:error-metadata)
  (:export #:set-metadata
           #:set-cache
           #:asset-path
           #:*fonts-css*
           #:*preloads*
           #:*preload-link*
           #:with-nm-request
           #:error-action
           #:error-page))
(in-package #:website/helper)

(defun asset-path (path &key (bust t))
  (format nil "/assets/~a~@[?v=~a~]" path (and bust #.(get-universal-time))))

(defun find-asset (dir glob)
  (let ((file (first (directory (format nil "assets/~a/~a" dir glob)))))
    (and file (format nil "~a/~a.~a" dir (pathname-name file) (pathname-type file)))))

(defparameter *fonts-css* (find-asset "style" "fonts-*.css"))

(defun css-field (rule key &key (end #\;))
  (let ((start (search key rule)))
    (and start
         (let ((from (+ start (length key))))
           (subseq rule from (or (position end rule :start from) (length rule)))))))

(defun font-face-rules (css)
  (loop
    :with start := 0
    :for open := (search "@font-face{" css :start2 start)
    :while open
    :for close := (position #\} css :start open)
    :collect (subseq css open close)
    :do (setf start close)))

(defun range-covers-p (range code)
  (loop
    :for token :in (uiop:split-string range :separator ",")
    :for spec := (subseq (string-trim " " token) 2)
    :for dash := (position #\- spec)
    :for lo := (parse-integer spec :end dash :radix 16)
    :for hi := (if dash (parse-integer spec :start (1+ dash) :radix 16) lo)
    :thereis (<= lo code hi)))

(defun shared-font-slices ()
  (let ((rules (and *fonts-css*
                    (font-face-rules (uiop:read-file-string (format nil "assets/~a" *fonts-css*))))))
    (loop
      :for (weight code) :in '((400 #x3042) (400 #x41) (700 #x3042) (700 #x41) (800 #x41))
      :for rule := (find-if (lambda (rule)
                              (and (= weight (parse-integer (css-field rule "font-weight:")))
                                   (range-covers-p (css-field rule "unicode-range:") code)))
                            rules :from-end t)
      :when rule :collect (css-field rule "url(" :end #\)))))

(defparameter *preloads*
  (append (list (cons (asset-path "style/dist.css") "style"))
          (and *fonts-css*
               (list (cons (asset-path *fonts-css* :bust nil) "style")))
          (loop
            :for url :in (shared-font-slices)
            :collect (cons url "font"))))

(defparameter *preload-link*
  (format nil "~{~a~^, ~}"
          (loop
            :for (url . as) :in *preloads*
            :collect (format nil "<~a>; rel=preload; as=~a~:[~;; crossorigin~]"
                             url as (string= as "font")))))

(defun set-metadata (metadata)
  (setf (context :metadata) metadata))

(defun set-cache (strategy)
  (cond ((dev-mode-p)
         (set-response-header :cache-control "private, no-store, must-revalidate"))
        ((eq strategy :ssr)
         (set-response-header :cache-control "public, max-age=0, must-revalidate"))
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
