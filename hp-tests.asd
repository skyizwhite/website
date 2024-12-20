(defsystem "hp-tests"
  :defsystem-depends-on ("wild-package-inferred-system")
  :class :package-inferred-system
  :pathname "tests"
  :depends-on ("fiveam"
               "hp-tests/example")
  :perform (test-op (o c)
                    (symbol-call :fiveam :run-all-tests)))
