(defsystem "hp"
  :description "My personal website"
  :author "Akira Tempaku <paku@skyizwhite.dev>"
  :class :package-inferred-system
  :pathname "src"
  :depends-on ("hp/main")
  :in-order-to ((test-op (test-op "hp-tests"))))
