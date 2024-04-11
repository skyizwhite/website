(defsystem "hp"
  :description "My personal project template for Common Lisp"
  :author "paku <paku@skyizwhite.dev>"
  :defsystem-depends-on ("wild-package-inferred-system")
  :class "winfer:wild-package-inferred-system"
  :pathname "src"
  :depends-on ("hp/app")
  :in-order-to ((test-op (test-op "hp-tests"))))

(register-system-packages "lack-middleware-accesslog" '(:lack.middleware.accesslog))
