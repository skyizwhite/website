(defsystem "website"
  :description "My personal website"
  :author "Akira Tempaku <paku@skyizwhite.dev>"
  :class :package-inferred-system
  :pathname "src"
  :depends-on ("clack-handler-woo"
               "clack-handler-hunchentoot"
               "website/main")
  :in-order-to ((test-op (test-op "website-tests"))))
