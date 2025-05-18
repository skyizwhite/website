(defpackage #:website/lib/cache
  (:use #:cl)
  (:import-from #:function-cache
                #:defcached
                #:clear-cache)
  (:export #:memorize
           #:clear-cache))
(in-package #:website/lib/cache)

(defmacro memorize (name)
  (let ((origin (gensym)))
    `(progn
       (setf (fdefinition ',origin) (fdefinition ',name))
       (defcached ,name (&rest args)
         (apply #',origin args)))))
