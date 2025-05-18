(defpackage #:website/lib/time
  (:use #:cl)
  (:import-from #:local-time
                #:reread-timezone-repository
                #:find-timezone-by-location-name
                #:parse-timestring
                #:format-timestring
                #:+asctime-format+)
  (:export #:datetime
           #:asctime))
(in-package #:website/lib/time)

(reread-timezone-repository)
(setf local-time:*default-timezone*
      (find-timezone-by-location-name "Asia/Tokyo"))

(defun datetime (timestring)
  (format-timestring nil
                     (parse-timestring timestring)
                     :format '(:year "-" (:month 2) "-" (:day 2) " "
                               (:hour 2) ":" (:min 2))))

(defun asctime (timestring)
  (format-timestring nil
                     (parse-timestring timestring)
                     :format +asctime-format+))
