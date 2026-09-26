(defpackage #:website/lib/string
  (:use #:cl)
  (:export #:squish))
(in-package #:website/lib/string)

(defun whitespace-char-p (char)
  (member char '(#\Space #\Tab #\Newline #\Return #\Page)))

(defun squish (string)
  "Collapse each run of whitespace in STRING into a single space and trim
both ends. Meant for code written across several lines in the source, such
as the JavaScript in nm-data and nm-bind; hsx emits attribute values as
written. Runs of spaces inside JS string literals are collapsed too."
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
