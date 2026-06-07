(defsystem "website-tests"
  :class :package-inferred-system
  :pathname "tests"
  :depends-on ("rove"
               "website-tests/components/metadata"
               "website-tests/lib/liked-posts"
               "website-tests/lib/time")
  :perform (test-op (o c) (symbol-call :rove :run c :style :dot)))
