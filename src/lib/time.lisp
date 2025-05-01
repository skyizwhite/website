(defpackage #:hp/lib/time
  (:use #:cl)
  (:import-from #:local-time
                #:reread-timezone-repository
                #:find-timezone-by-location-name
                #:parse-timestring
                #:format-timestring)
  (:export #:datetime
           #:jp-datetime))
(in-package #:hp/lib/time)

(reread-timezone-repository)
(setf local-time:*default-timezone*
      (find-timezone-by-location-name "Asia/Tokyo"))

(defun datetime (timestring)
  (format-timestring nil
                     (parse-timestring timestring)
                     :format '(:year "-" (:month 2) "-" (:day 2) " "
                               (:hour 2) ":" (:min 2))))

(defun jp-datetime (timestring)
  (format-timestring nil
                     (parse-timestring timestring)
                     :format '(:year "年" :month "月" :day "日" " "
                               :hour "時" :min "分")))
