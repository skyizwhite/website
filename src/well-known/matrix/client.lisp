(defpackage #:website/well-known/matrix/client
  (:use #:cl
        #:website/helper)
  (:import-from #:website/lib/matrix
                #:*homeserver-base-url*)
  (:export #:@get))
(in-package #:website/well-known/matrix/client)

(defun @get (params)
  (declare (ignore params))
  (list :|m.homeserver| (list :|base_url| *homeserver-base-url*)))
