(defun v-php-doc (func-name)
  "show php doc by region"
  (interactive (list
		(read-string (format "Enter the word (%s): "
				     (thing-at-point 'symbol)
				     )
			     nil 1 (thing-at-point 'symbol))
		))
  (let ((doc-dir "~/.emacs.d/docs/php-chunked-xhtml/")
	)
    (v-php-doc-browse func-name doc-dir)
    ))
(defun v-php-doc-browse (func-name doc-dir)
  (let ((suffix-filename (concat (replace-regexp-in-string
				  "_"
				  "-"
				  (downcase func-name))
				 ".html"))
	(php-symbol-list '("function" "class" "book" "intro"))
	(search-php-file
	 (lambda (php-file-name)
	   (catch 'find-file
	     (if (file-exists-p php-file-name)
		 (progn (eww-open-file php-file-name) (throw 'find-file t))
	       (throw 'find-file nil)))
	   )
	 )
	)
    (deactivate-mark)
    (dolist (php-symbol php-symbol-list)
      (and (funcall search-php-file
		    (concat doc-dir php-symbol "." suffix-filename))
	   (return))
      )
    (and (funcall search-php-file (concat doc-dir suffix-filename))
	 (return))
    (message "Function or class not exists.")
    ) ; end let
  ) ; end defun
