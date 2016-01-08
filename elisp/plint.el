;; Checking php syntax by "php -l"
(defun plint ()
  "Checking php syntax by php -l"
  (interactive)
  (if (buffer-file-name)
      (shell-command (concat "php -l "  (buffer-file-name) ))
    (message "file not found")
    )
  )
