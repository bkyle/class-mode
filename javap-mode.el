;;; -*-mode: emacs-lisp; indent-with-tabs: nil-*-
;;;
;;; Author: Bryan Kyle <bryan.kyle@gmail.com>
;;; Date: 2021-04-11
;;;
;;; javap-mode - Syntax highlighting for javap dumps of classes
;;;

(defconst javap-mode-font-lock-keywords
  (list
   `(,(rx word-start
         (group
          (or "aaload" "aastore" "aconst_null" "aload" "aload_0" "aload_1"
              "aload_2" "aload_3" "anewarray" "areturn" "arraylength" "astore"
              "astore_0" "astore_1" "astore_2" "astore_3" "athrow" "baload"
              "bastore" "bipush" "caload" "castore" "checkcast" "d2f" "d2i" "d2l"
              "dadd" "daload" "dastore" "dcmpg" "dcmpl" "dconst_0" "dconst_1"
              "ddiv" "dload" "dload_0" "dload_1" "dload_2" "dload_3" "dmul" "dneg"
              "drem" "dreturn" "dstore" "dstore_0" "dstore_1" "dstore_2"
              "dstore_3" "dsub" "dup" "dup_x1" "dup_x2" "dup2" "dup2_x1" "dup2_x2"
              "f2d" "f2i" "f2l" "fadd" "faload" "fastore" "fcmpg" "fcmpl"
              "fconst_0" "fconst_1" "fconst_2" "fdiv" "fload" "fload_0" "fload_1"
              "fload_2" "fload_3" "fmul" "fneg" "frem" "freturn" "fstore"
              "fstore_0" "fstore_1" "fstore_2" "fstore_3" "fsub" "getfield"
              "getstatic" "goto" "goto_w" "i2b" "i2c" "i2d" "i2f" "i2l" "i2s"
              "iadd" "iaload" "iand" "iastore" "iconst_m1" "iconst_0" "iconst_1"
              "iconst_2" "iconst_3" "iconst_4" "iconst_5" "idiv" "if_acmpeq"
              "if_acmpne" "if_icmpeq" "if_icmpne" "if_icmplt" "if_icmpge"
              "if_icmpgt" "if_icmple" "ifeq" "ifne" "iflt" "ifge" "ifgt" "ifle"
              "ifnonnull" "ifnull" "iinc" "iload" "iload_0" "iload_1" "iload_2"
              "iload_3" "imul" "ineg" "instanceof" "invokedynamic"
              "invokeinterface" "invokespecial" "invokestatic" "invokevirtual"
              "ior" "irem" "ireturn" "ishl" "ishr" "istore" "istore_0" "istore_1"
              "istore_2" "istore_3" "isub" "iushr" "ixor" "jsr" "jsr_w" "l2d"
              "l2f" "l2i" "ladd" "laload" "land" "lastore" "lcmp" "lconst_0"
              "lconst_1" "ldc" "ldc_w" "ldc2_w" "ldiv" "lload" "lload_0" "lload_1"
              "lload_2" "lload_3" "lmul" "lneg" "lookupswitch" "lor" "lrem"
              "lreturn" "lshl" "lshr" "lstore" "lstore_0" "lstore_1" "lstore_2"
              "lstore_3" "lsub" "lushr" "lxor" "monitorenter" "monitorexit"
              "multianewarray" "new" "newarray" "nop" "pop" "pop2" "putfield"
              "putstatic" "ret" "return" "saload" "sastore" "sipush" "swap"
              "tableswitch" "wide"))
         word-end) . font-lock-constant-face)
   `(,(rx word-start
          (group
           (or "private" "public" "protected" "class" "interface" "static" "final"
               "volatile" "extends" "implements" "synchronized" "package" "import" ))
          word-end) . font-lock-keyword-face)
   ;; `(,(rx word-start (group alpha (* (any alphanumeric "."))) word-end) . font-lock-variable-name-face)
   `(,(rx (group (? "[") "L" alpha (* (any alphanumeric "/" "$"))) ";") . font-lock-type-face)
   `(,(rx "#" (+ digit)) . font-lock-variable-name-face)))

   ;; '("\\<\\(include\\|struct\\|exception\\|typedef\\|const\\|enum\\|service\\|extends\\|void\\|oneway\\|throws\\|optional\\|required\\)\\>" . font-lock-keyword-face)  ;; keywords

(defvar javap-mode-syntax-table
  (let ((javap-mode-syntax-table (make-syntax-table)))
    (modify-syntax-entry ?/ ". 12" javap-mode-syntax-table)
    (modify-syntax-entry ?\n ">b" javap-mode-syntax-table)
    javap-mode-syntax-table)
  "Syntax table for javap-mode")

(defun javap-mode ()
  "Mode for viewing javap dumps of .class files"
  (interactive)
  (kill-all-local-variables)
  (set-syntax-table javap-mode-syntax-table)
  (set (make-local-variable 'font-lock-defaults) '(javap-mode-font-lock-keywords))
  (setq major-mode 'javap-mode)
  (setq mode-name "Javap")
  (run-hooks 'javap-mode-hook))

(provide 'javap-mode)
