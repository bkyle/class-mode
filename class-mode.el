;;; -*-Emacs-Lisp-*-
;;;
;;; Author: Bryan Kyle <bryan.kyle@gmail.com>
;;; Date: 2009-10-29
;;;
;;; Class Mode - View Java class files from within emacs
;;;
;;; Overview:
;;;
;;; class-mode is a major mode that allows you to view java class files in
;;; decompiled form.  class-mode provides the following features:
;;;
;;;   * automatically decompile classes on open
;;;
;;; TODO:
;;;   * configure decompiler (javap, jad, etc)
;;;
;;; Usage:
;;;
;;; (0) modify .emacs to load class-mode.
;;;     for example :
;;;
;;;     (autoload 'class-mode "class-mode" nil t)
;;;     (add-to-list 'auto-mode-alist '("\\.class$" . class-mode))
;;;
;;;

(defun class-mode ()
  "Major mode for viewing Java class files."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'class-mode)
  (setq mode-name "Class")
  (class-decompile))
  
(defun class-decompile-file (filename &optional buffer)
  "Decompiles a java class file.  Optionally a buffer can be given that will receive
the decompiled code."
  ; Need save-selected-window and save-window-excursion so that the split that shell-command
  ; does isn't retained.
  (message (format "Decompiling %s" filename))
  (save-selected-window
	(save-window-excursion
	  (shell-command (concat "javap -c -l -s -private " (file-name-sans-extension filename)) buffer))))


(defun class-decompile ()
  "Decompiles a java class file in the current buffer."

  (let (data filename)
	(setq data (buffer-substring (point-min) (point-max)))
	(delete-region (point-min) (point-max))
	(setq filename (file-name-nondirectory buffer-file-name))
	(with-temp-file filename
	  (set-buffer-file-coding-system 'binary)
	  (insert data))
	(class-decompile-file filename (current-buffer))
	(delete-file filename)
	(goto-char (point-min))
	(set-buffer-modified-p nil)))

