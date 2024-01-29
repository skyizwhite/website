(defsystem "hp-tests"
  :defsystem-depends-on ("wild-package-inferred-system")
  :class "winfer:wild-package-inferred-system"
  :pathname "tests"
  :depends-on ("fiveam"
               "hp-tests/**/*")
  :perform (test-op (o c)
                    (symbol-call :fiveam :run-all-tests)))
