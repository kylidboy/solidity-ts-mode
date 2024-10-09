;;; pacakge --- Summary: solidity-ts-mode.el -*- lexical-binding: t; -*-
;;;
;;; Commentary:
;;;
;;; Code:
;;;

(define-derived-mode solidity-ts-mode solidity-mode "Solidity[ts]"
  "..."
  :syntax-table nil
  (setq-local font-lock-defaults nil)
  (when (treesit-ready-p 'solidity)
    (treesit-parser-create 'solidity)
    (solidity-ts-setup)))

(defvar solidity-ts-font-lock-rules
  '(
    :language solidity
    :override t
    :feature tags
    ((pragma_directive) @font-lock-preprocessor-face
     (solidity_version_comparison_operator _ @font-lock-preprocessor-face))


    :language solidity
    :override t
    :feature constants
    ([
      "wei"
      "gwei"
      "ether"
      "seconds"
      "minutes"
      "hours"
      "days"
      "weeks"
      (true)
      (false)]
     @font-lock-constant-face)


    :language solidity
    :override t
    :feature string
    ([
      (string)
      (hex_string_literal)
      (unicode_string_literal)
      (yul_string_literal)]
     @font-lock-string-face)


    :language solidity
    :override t
    :feature numbers
    ([
      (number_literal)
      (yul_decimal_number)
      (yul_hex_number)]
     @font-lock-number-face)


    :language solidity
    :override t
    :feature comments
    ((comment) @font-lock-comment-face)


    :language solidity
    :override t
    :feature loop-controls
    ([
      "for"
      "while"
      "do"]
     @font-lock-keyword-face)


    :language solidity
    :override t
    :feature keywords
    ([
      "pragma"
      "contract"
      "interface"
      "library"
      "is"
      "struct"
      "enum"
      "event"
      "using"
      "assembly"
      "public"
      "internal"
      "private"
      "external"
      "pure"
      "view"
      "memory"
      "storage"
      "calldata"
      "var"
      "constant"
      "function"
      "modifier"
      (virtual)
      (override_specifier)
      (yul_leave)]
     @font-lock-keyword-face

     ("emit" @font-lock-function-call-face)
     ("payable" @font-lock-warnibng-face))


    :language solidity
    :override t
    :feature conditional-controls
    ([
      "if"
      "else"
      "switch"
      "case"
      "default"]
     @font-lock-keyword-face)


    :language solidity
    :override t
    :feature try-catch
    ([
      "try"
      "catch"]
     @font-lock-keyword-face)


    :language solidity
    :override t
    :feature critical-keywords
    ([
      "return"
      "returns"
      "break"
      "continue"]
     @font-lock-warning-face)


    :language solidity
    :override t
    :feature builtins
    ([
      "msg"
      "block"
      "tx"]
     @font-lock-builtin-face)


    :language solidity
    :override t
    :feature imports
    (
     ("import" @font-lock-keyword-face)
     (import_directive "as" @font-lock-keyword-face)
     (import_directive "from" @font-lock-keyword-face))


    :language solidity
    :override t
    :feature brackets
    ([
      "("
      ")"
      "["
      "]"
      "{"
      "}"]
     @font-lock-bracket-face)


    :language solidity
    :override t
    :feature delimiters
    (["." ","] @font-lock-delimiter-face)


    :language solidity
    :override t
    :feature operators
    ([
      "&&"
      "||"
      ">>"
      ">>>"
      "<<"
      "&"
      "^"
      "|"
      "+"
      "-"
      "*"
      "/"
      "%"
      "**"
      "<"
      "<="
      "=="
      "!="
      "!=="
      ">="
      ">"
      "!"
      "~"
      "-"
      "+"
      "++"
      "--"]
     @font-lock-operator-face)


    :language solidity
    :override t
    :feature critical-operators
    (["delete" "new"] @font-lock-operator-face)


    :language solidity
    :override t
    :feature identifiers
    (
     (struct_declaration
      name: (identifier) @font-lock-type-face)
     (enum_declaration
      name: (identifier) @font-lock-type-face)
     (contract_declaration
      name: (identifier) @font-lock-type-face)
     (library_declaration
      name: (identifier) @font-lock-type-face)
     (interface_declaration
      name: (identifier) @font-lock-type-face)
     (event_definition
      name: (identifier) @font-lock-function-name-face)
     (function_definition
      name: (identifier) @font-lock-function-name-face)
     (modifier_definition
      name: (identifier) @font-lock-function-name-face)
     ((yul_evm_builtin) @font-lock-builtin-face))


    :language solidity
    :override t
    :feature invocations
    (
     (emit_statement (_) @font-lock-negation-char-face)
     (modifier_invocation (identifier) @font-lock-preprocessor-face)

     (call_expression (_(member_expression property: (_) @font-lock-function-call-face)))
     (call_expression (expression(identifier)) @font-lock-function-call-face)

     ;; Function parameters
     (call_struct_argument name: (_) @font-lock-property-use-face)
     (event_parameter name: (identifier) @font-lock-variable-name-face)
     (parameter name: (identifier) @font-lock-variable-name-face)

     ;; Yul functions
     (yul_function_call function: (yul_identifier) @font-lock-function-call-face)
     (yul_function_definition (yul_identifier) @font-lock-function-name-face (yul_identifier) @font-lock-variable-name-face)

     ;; Structs and members
     (member_expression property: (identifier) @font-lock-property-name-face)
     (struct_expression type: ((expression(identifier)) @font-lock-negation-char-face))
     (struct_field_assignment name: (identifier) @font-lock-property-use-face))


    :language solidity
    :override t
    :feature definitions
    (
     ((type_name) @font-lock-type-face)
     ((primitive_type) @font-lock-type-face)
     (user_defined_type (identifier) @font-lock-type-face)

     (payable_conversion_expression "payable" @font-lock-warning-face)

     ;; Ensures that delimiters in mapping( ... => .. ) are not colored like types
     (type_name "(" @font-lock-bracket-face "=>" @font-lock-punctuation-face")" @font-lock-bracket-face)

     ;; Use contructor coloring for special functions
     (constructor_definition "constructor" @font-lock-function-name-face)
     (fallback_receive_definition "receive" @font-lock-function-name-face)
     (fallback_receive_definition "fallback" @font-lock-function-name-face)

     (struct_member name: (identifier) @font-lock-property-name-face)
     ((enum_value) @font-lock-constant-face)

     (meta_type_expression "type" @font-lock-keyword-face)

     ("error" @font-lock-type-face)

     (event_parameter "indexed" @font-lock-warning-face))))



(defun solidity-ts-setup ()
  "..."
  (setq-local treesit-font-lock-feature-list
              '((comments definitions)
                (string
                 constants
                 ;; builtins
                 critical-keywords)
                (imports
                 tags
                 loop-controls
                 conditional-controls
                 critical-operators
                 try-catch
                 keywords
                 identifiers)
                (numbers
                 delimiters
                 operators
                 brackets
                 delimitors
                 invocations)))
  (setq-local treesit-font-lock-settings
              (apply #'treesit-font-lock-rules solidity-ts-font-lock-rules))
  ;; (setq-local treesit-simple-indent-rules solidity-ts-indent-rules)
  (setq-local treesit-font-lock-level 4)
  (treesit-major-mode-setup))

(provide 'solidity-ts-mode)
;;; solidity-ts-mode.el ends here
