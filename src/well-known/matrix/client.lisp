(defpackage #:website/well-known/matrix/client
  (:use #:cl
        #:website/helper)
  (:import-from #:website/lib/matrix
                #:*homeserver-base-url*)
  (:export #:@get))
(in-package #:website/well-known/matrix/client)

(defun @get (params)
  (declare (ignore params))
  (set-cache :sg)
  (list :|m.homeserver| (list :|base_url| *homeserver-base-url*)))
