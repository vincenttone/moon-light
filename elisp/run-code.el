(defun v-language-list () '("sh" "php" "lua" "python" "ruby"))
(dolist (cmd (v-language-list))
  (eval `(defun
           ,(intern
             (concat "v-" cmd "-run-current-file"))
           ()
           (interactive) (v-run-current-file ,cmd)
           ))
  )

(defun v-run-current-file (cmd)
  (if (buffer-file-name)
      (let ((result (shell-command-to-string
                     (concat cmd " "  (buffer-file-name) ))))
        (with-help-window (help-buffer) (princ result)))
    (message "file not found")
    )
  )

(defun v-run-php-code (beg end)
  (interactive
   (if (use-region-p)
       (list (region-beginning) (region-end))
     (list nil nil)))
  (if (or (equal beg nil) (equal end nil))
      (message "Empty input.")
    (let ((code (buffer-substring-no-properties beg end)))
      (message (shell-command-to-string
                (concat "php -r \""
                        code "\"")))))
  )
