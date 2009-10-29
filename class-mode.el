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
;;;   * automatically decompile classes on open.
;;;   * support javap (default) and jad.
;;;   * automatically switches to java-mode when decompiler produces source.
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

(defun class-decompile-javap (filename buffer)
  "Decompiles the given class file using javap and places the result in the
passed buffer."

  ; Need save-selected-window and save-window-excursion so that the split that shell-command
  ; does isn't retained.
  (save-selected-window
	(save-window-excursion
	  (shell-command (concat "javap -c -l -s -private" " " (file-name-sans-extension filename)) buffer))))

(defun class-decompile-jad (filename buffer)
  "Decompiles the given class file using jad and places the result in the
passed buffer."

  ; Need save-selected-window and save-window-excursion so that the split that shell-command
  ; does isn't retained.
  (save-selected-window
	(save-window-excursion
	  (shell-command (concat "jad -b -lnc -s java" " " filename) (current-buffer))
	  (let (buffer source-file data)
		(setq source-file (concat (file-name-sans-extension filename) ".java"))
		(setq buffer (current-buffer))

		; load the file
		(find-file source-file)
		(setq data (buffer-substring (point-min) (point-max)))
		(kill-buffer)

		(pop-to-buffer buffer)
		(delete-region (point-min) (point-max))
		(insert data)
		(java-mode)

		(delete-file source-file)))))

(defvar class-mode-decompile-function 'class-decompile-javap
  "Decompiler function to use to decompile a class.  Possible values are
'class-decomple-javap and 'class-decompile-jad.")

(defun class-mode ()
  "Major mode for viewing Java class files."
  (interactive)
  (kill-all-local-variables)
  (setq major-mode 'class-mode)
  (setq mode-name "Class")
  (class-decompile))

  
(defun class-decompile-file (filename  buffer)
  "Decompiles a java class file.  Optionally a buffer can be given that will receive
the decompiled code."
  (message (format "Decompiling %s" filename))
  (apply class-mode-decompile-function filename buffer '()))

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

(setq class-mode-decompile-command "jad -b -lnc -&")
(setq class-mode-major-mode-post-decompile 'java-mode)