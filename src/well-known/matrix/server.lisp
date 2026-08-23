(defpackage #:website/well-known/matrix/server
  (:use #:cl
        #:website/helper)
  (:import-from #:website/lib/matrix
                #:*homeserver-delegation*)
  (:export #:@get))
(in-package #:website/well-known/matrix/server)

(defun @get (params)
  (declare (ignore params))
  (list :|m.server| *homeserver-delegation*))
