(defpackage #:website/lib/string
  (:use #:cl)
  (:export #:squish))
(in-package #:website/lib/string)

(defun whitespace-char-p (char)
  (member char '(#\Space #\Tab #\Newline #\Return #\Page)))

(defun squish (string)
  (with-output-to-string (out)
    (let ((gap nil)
          (started nil))
      (loop
        :for char :across string
        :do (cond ((whitespace-char-p char)
                   (setf gap started))
                  (t
                   (when gap
                     (write-char #\Space out))
                   (write-char char out)
                   (setf gap nil
                         started t)))))))
