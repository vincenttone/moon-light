;; You can get popup here: https://github.com/auto-complete/popup-el.git
;; and ydcv here: https://github.com/felixonmars/ydcv
;; add ydcv to PATH
(require 'popup)
;; Translating by ydcv
(defun ydcv (string)
  "vince's elisp ydcv"
  (interactive (list
                (read-string (format "Enter the word (%s): "
                                     (thing-at-point 'word))
                             nil 1 (thing-at-point 'word))
                ))
  (if (= (length string) 0)
      (popup-tip "\n  Please input word.  \n")
    (let ((result (shell-command-to-string
                   (concat "ydcv '"
                           string "'"))))
      (popup-tip result))
    )
  )
