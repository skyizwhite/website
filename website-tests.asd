(defsystem "website-tests"
  :class :package-inferred-system
  :pathname "tests"
  :depends-on ("fiveam"
               "website-tests/example")
  :perform (test-op (o c)
                    (symbol-call :fiveam :run-all-tests)))
