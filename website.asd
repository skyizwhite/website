(defsystem "website"
  :description "My personal website"
  :author "Akira Tempaku <paku@skyizwhite.dev>"
  :class :package-inferred-system
  :pathname "src"
  :depends-on ("website/main")
  :in-order-to ((test-op (test-op "website-tests"))))
