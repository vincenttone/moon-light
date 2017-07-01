;;; user info
(setq user-full-name "Vincent,Tone")
(setq user-mail-address "tongwensong@gmail.com")
;(global-hl-line-mode 1)
(global-linum-mode 1)
(setq inhibit-startup-message t)
;(global-whitespace-mode 1)
(setq scroll-step 1)
(show-paren-mode 1)
(setq column-number-mode 1)
(setq-default indent-tabs-mode nil)
(setq standard-indent 4)
(setq make-backup-files nil)
(menu-bar-mode -1)
(set-cursor-color "red")
(set-mouse-color "goldenrod")
(set-face-foreground 'region "purple")
(set-face-background 'region "green")

(if window-system (tool-bar-mode 0))

;(setq whitespace-style '(trailing tabs newline tab-mark newline-mark))
(setq whitespace-style (quote (spaces tabs newline space-mark tab-mark newline-mark)))
(setq whitespace-display-mappings
      ;; all numbers are Unicode codepoint in decimal. try (insert-char 182 ) to see it
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
        (newline-mark 10 [182 10]) ; 10 LINE FEED
        (tab-mark 9 [8677 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))
(setq plugin-file-path "/home/vincent/.emacs.d/plugins")
(add-to-list 'load-path plugin-file-path)
(require 'smex)
(global-set-key [(meta x)] 'smex)
; (require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
(package-initialize)
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")))

; (require 'bison-mode)
; (require 'markdown-mode)
(load "ydcv.elc")
(load "phpdoc.elc")
(load "plint.elc")
(load "run-code.elc")
; (load "vltools.elc")
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wheatgrass))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
(set-default-font "monaco-18")
(global-set-key (kbd "C-c f") 'forward-list)
(global-set-key (kbd "C-c b") 'backward-list)
; (require 'auto-complete-config)
; (ac-config-default)
;; ac-php
(unless (package-installed-p 'ac-php )
    (package-refresh-contents)
    (package-install 'ac-php )
    )
(require 'cl)
;;  (require 'php-mode)
(add-hook 'php-mode-hook
		  '(lambda ()
			 (auto-complete-mode t)
			 (require 'ac-php)
			 ;;(setq ac-php-use-cscope-flag  t ) ;;enable cscope
			 (setq ac-sources  '(ac-source-php ) )
			 (yas-global-mode 1)
			 (define-key php-mode-map  (kbd "C-]") 'ac-php-find-symbol-at-point)   ;goto define
			 (define-key php-mode-map  (kbd "C-t") 'ac-php-location-stack-back   ) ;go back
			 ))
;;;; load & configure js2-mode
(autoload 'js2-mode "js2-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))
(add-to-list 'auto-mode-alist '("\\.cson$" . js2-mode))

;;; set to tab
(setq-default indent-tabs-mode t)
(setq-default tab-width 4) ; Assuming you want your tabs to be four spaces wide
(defvaralias 'c-basic-offset 'tab-width)
(require 'flymake-php)
(add-hook 'php-mode-hook 'flymake-php-load)

(require 'ac-helm) ;; Not necessary if using ELPA package
(global-set-key (kbd "C-:") 'ac-complete-with-helm)
(define-key ac-complete-mode-map (kbd "C-:") 'ac-complete-with-helm)
;; erlang mode
(add-to-list 'auto-mode-alist '("\\.erl$" . erlang-mode))
(add-to-list 'auto-mode-alist '("\\.hrl$" . erlang-mode))

(require 'window-number)
(window-number-mode 1)
; (global-set-key (kbd "C-x o") 'window-number-switch)
(setq default-tab-width 4)
(setq-default indent-tabs-mode nil)
(setq c-default-style "Linux")
(setq c-basic-offset 4)
