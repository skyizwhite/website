(defsystem "hp"
  :description "My personal project template for Common Lisp"
  :author "paku <paku@skyizwhite.dev>"
  :class :package-inferred-system
  :pathname "src"
  :depends-on ("hp/main")
  :in-order-to ((test-op (test-op "hp-tests"))))

(register-system-packages "lack-middleware-static" '(:lack.middleware.static))
(register-system-packages "lack-middleware-accesslog" '(:lack.middleware.accesslog))
