(defsystem "website-tests"
  :class :package-inferred-system
  :pathname "tests"
  :depends-on ("rove"
               "website-tests/example")
  :perform (test-op (o c) (symbol-call :rove :run c :style :dot)))
