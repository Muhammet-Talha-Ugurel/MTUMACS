(menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
  (package-initialize)

(unless (package-installed-p 'use-package)
(package-install 'use-package))

(delete-selection-mode t)

(use-package doom-themes
:ensure t
:config
;; Global settings (defaults)
(setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
	    doom-themes-enable-italic t) ; if nil, italics is universally disabled
;;(load-theme 'doom-homage-black t)
      ;;(load-theme 'soothe t nil)
(load-theme 'doom-acario-dark t)
;;(load-theme 'doom-tokyo-night t)
;;(load-theme 'doom-one t)
(doom-themes-org-config))

(use-package all-the-icons :ensure t)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)
(dolist (mode '(org-mode-hook
				term-mode-hook
				shell-mode-hook
				eshell-mode-hook))
(add-hook mode (lambda () (display-line-numbers-mode 0))))
(use-package beacon
:ensure t)
(beacon-mode t)

(use-package dashboard
  :ensure t
  :init      ;; tweak dashboard config before loading it
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-banner-logo-title "MTUEMACS")
  (setq dashboard-startup-banner "~/.emacs-mtumacs.d/the-logo-of-the-best-editor.png")  ;; use custom image as banner
  (setq dashboard-center-content t) ;; set to 't' for centered content
  (setq dashboard-items '((recents . 5)
                          (agenda . 5 )
                          (bookmarks . 3)
                          (projects . 3)
                          (registers . 3)))
  :config
  (dashboard-setup-startup-hook)
  (dashboard-modify-heading-icons '((recents . "file-text")
			      (bookmarks . "book"))))

(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

(use-package doom-modeline
:ensure t)
(doom-modeline-mode 1)

(setq scroll-conservatively 101) ;; value greater than 100 gets rid of half page jumping
(setq mouse-wheel-scroll-amount '(3 ((shift) . 3))) ;; how many lines at a time
(setq mouse-wheel-progressive-speed t) ;; accelerate scrolling
(setq mouse-wheel-follow-mouse 't)

(use-package minimap
:ensure t)
(setq minimap-window-location 'right)

(use-package projectile
  :ensure t
  :config
  (projectile-global-mode 1))

(use-package ivy
	:ensure t
	:diminish
	:bind (("C-s" . swiper)
		 :map ivy-minibuffer-map
		 ("TAB" . ivy-alt-done)
		 ("C-a" . ivy-alt-done)
		 ("C-j" . ivy-next-line)
		 ("C-k" . ivy-previous-line)
		 :map ivy-switch-buffer-map
		 ("C-k" . ivy-previous-line)
		 ("C-l" . ivy-done)
		 ("C-d" . ivy-switch-buffer-kill)
		 :map ivy-reverse-i-search-map
		 ("C-k" . ivy-previous-line)
		 ("C-d" . ivy-reverse-i-search-kill))
	:config
	(ivy-mode 1))
(use-package ivy-rich
	:after ivy
	:ensure t
	:init
	(ivy-rich-mode 1))

(use-package counsel
	:ensure t
	:bind (("M-x" . counsel-M-x)
				 ("C-x b" . counsel-ibuffer)
				 ("C-x C-f" . counsel-find-file)
				 :map minibuffer-local-map
				 ("C-r" . 'counsel-minibuffer-history)))
(use-package smex
:ensure t)

(use-package rainbow-delimiters
  :ensure t
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects/Code")
    (setq projectile-project-search-path '("~/Projects/Code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :ensure t)
;;(use-package forge
 ;;:ensure t)

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
			  '(("^ *\\([-]\\) "
			     (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
		  (org-level-2 . 1.1)
		  (org-level-3 . 1.05)
		  (org-level-4 . 1.0)
		  (org-level-5 . 1.1)
		  (org-level-6 . 1.1)
		  (org-level-7 . 1.1)
		  (org-level-8 . 1.1)))
    )

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil   :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil :inherit 'fixed-pitch))

(use-package org
:ensure t
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (efs/org-font-setup))

(use-package org-bullets
:ensure t
  :after org
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
	visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
:ensure t
  :hook (org-mode . efs/org-mode-visual-fill))

(use-package evil
  :ensure t
  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (setq evil-want-C-i-jump nil)
  (evil-mode))
(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer))
  (evil-collection-init))
(use-package evil-tutor)

(use-package general
  :ensure t
  :config
  (general-evil-setup t))

(use-package which-key
  :ensure t
  :init
  (setq which-key-side-window-location 'bottom
        which-key-sort-order #'which-key-key-order-alpha
        which-key-sort-uppercase-first nil
        which-key-add-column-padding 1
        which-key-max-display-columns nil
        which-key-min-display-lines 6
        which-key-side-window-slot -10
        which-key-side-window-max-height 0.25
        which-key-idle-delay 0.8
        which-key-max-description-length 25
        which-key-allow-imprecise-window-fit t
        which-key-separator " → " ))
(which-key-mode)

;; BUFFER keys
(nvmap :prefix "SPC"
	"b"     '(:which-key "Ibuffer")
	"b b"   '(ibuffer :which-key "Ibuffer")
	"b c"   '(clone-indirect-buffer-other-window :which-key "Clone indirect buffer other window")
	"b k"   '(kill-current-buffer :which-key "Kill current buffer")
	"]"   '(next-buffer :which-key "Next buffer")
	"b n"   '(next-buffer :which-key "Next buffer")
	"["   '(previous-buffer :which-key "Previous buffer")
	"b p"   '(previous-buffer :which-key "Previous buffer")
	"b B"   '(ibuffer-list-buffers :which-key "Ibuffer list buffers")
	"b K"   '(kill-buffer :which-key "Kill buffer"))
;;FILE keys
(nvmap :states '(normal visual) :keymaps 'override :prefix "SPC"
	"."     '(find-file :which-key "Find file")
	"f f"   '(find-file :which-key "Find file")
	"f r"   '(counsel-recentf :which-key "Recent files")
	"f s"   '(save-buffer :which-key "Save file")
	"f u"   '(sudo-edit-find-file :which-key "Sudo find file")
	"f y"   '(dt/show-and-copy-buffer-path :which-key "Yank file path")
	"f C"   '(copy-file :which-key "Copy file")
	"f D"   '(delete-file :which-key "Delete file")
	"f R"   '(rename-file :which-key "Rename file")
	"f S"   '(write-file :which-key "Save file as...")
	"f U"   '(sudo-edit :which-key "Sudo edit file"))
;; ZOOM IN and OUT
(global-set-key (kbd "C-=") 'text-scale-increase)
(global-set-key (kbd "C--") 'text-scale-decrease)
;;CONFIG keys
(nvmap :keymaps 'override :prefix "SPC"
	"SPC"   '(counsel-M-x :which-key "M-x")
	"c c"   '(compile :which-key "Compile")
	"c C"   '(recompile :which-key "Recompile")
	"r r" '((lambda () (interactive) (load-file "~/.emacs-mtumacs.d/init.el")) :which-key "Reload emacs config")
	"t t"   '(toggle-truncate-lines :which-key "Toggle truncate lines"))
;; TAB mode keys
(nvmap :keymaps 'override :prefix "SPC"
	"t n"   '(tab-next :which-key "Swich to next tab")
	"t ."   '(tab-next :which-key "Swich to next tab")
	"t ,"   '(tab-previous :which-key "Swich to previous tab"))
;; ORG mode keys
(nvmap :keymaps 'override :prefix "SPC"
	"o *"   '(org-ctrl-c-star :which-key "Org-ctrl-c-star")
	"o +"   '(org-ctrl-c-minus :which-key "Org-ctrl-c-minus")
	"o ."   '(counsel-org-goto :which-key "Counsel org goto")
	"o e"   '(org-export-dispatch :which-key "Org export dispatch")
	"o f"   '(org-footnote-new :which-key "Org footnote new")
	"o h"   '(org-toggle-heading :which-key "Org toggle heading")
	"o i"   '(org-toggle-item :which-key "Org toggle item")
	"o n"   '(org-store-link :which-key "Org store link")
	"o o"   '(org-set-property :which-key "Org set property")
	"o t"   '(org-todo :which-key "Org todo")
	"o x"   '(org-toggle-checkbox :which-key "Org toggle checkbox")
	"o B"   '(org-babel-tangle :which-key "Org babel tangle")
	"o I"   '(org-toggle-inline-images :which-key "Org toggle inline imager")
	"o T"   '(org-todo-list :which-key "Org todo list")
	"o a"   '(org-agenda :which-key "Org agenda"))

(defun efs/lsp-mode-setup ()
  (setq lsp-headerline-breadcrumb-segments '(path-up-to-project file symbols))
  (lsp-headerline-breadcrumb-mode))
  (use-package lsp-mode
  :ensure t
	:commands (lsp lsp-deferred)
	:hook (lsp-mode . efs/lsp-mode-setup)
	:init
	(setq lsp-keymap-prefix "C-l")  ;; 'C-l'
	:config
  (lsp-enable-which-key-integration t))

(setq-default indent-tabs-mode t)
(setq backward-delete-char-untabify-method nil)
(setq-default tab-width 2)
(setq indent-tabs-mode t)
(defun my-insert-tab-char ()
(interactive)
(insert "\t"))
(global-set-key (kbd "TAB") 'my-insert-tab-char)
;;(add-hook 'c-mode-hook ;; guessing
	;; '(lambda ()
	;;(local-set-key "TAB" 'my-insert-tab-char)))

;(defvar bootstrap-version)
;(let ((bootstrap-file
;       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
;      (bootstrap-version 6))
;  (unless (file-exists-p bootstrap-file)
;    (with-current-buffer
;        (url-retrieve-synchronously
;         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
;         'silent 'inhibit-cookies)
;      (goto-char (point-max))
;      (eval-print-last-sexp)))
;  (load bootstrap-file nil 'nomessage))

; 		(use-package copilot
; 		  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
; 		:commands (copilot-mode)
; 		  :ensure t)
; 	(with-eval-after-load 'company
; 	  ;; disable inline previews
; 	  (delq 'company-preview-if-just-one-frontend company-frontends))
;  
; 	(define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
; 	(define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
;  (defun my-tab ()
; 	(interactive)
; 	(or (copilot-accept-completion)
; 		(ac-expand nil)))
; 
;  (with-eval-after-load 'auto-complete
; 	; disable inline preview
; 	(setq ac-disable-inline t)
; 	; show menu if have only one candidate
; 	(setq ac-candidate-menu-min 0))
;  
;  (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
;  (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion)
;(with-eval-after-load 'copilot
;  (evil-define-key 'insert copilot-mode-map
;    (kbd "<tab>") #'my/copilot-tab))

(use-package term
		:ensure t
			:config
			(setq explicit-shell-file-name "bash") ;; Change this to zsh, etc
			;;(setq explicit-zsh-args '())         ;; Use 'explicit-<shell>-args for shell-specific args

			;; Match the default Bash shell prompt.  Update this if you have a custom prompt
			(setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *"))
;;		(use-package eterm-256color
;;		:ensure t
;;		  :hook (term-mode . eterm-256color-mode 1))
		(use-package vterm
		:ensure t
		:commands vterm
		:config
		(setq term-prompt-regexp "^[^#$%>\n]*[#$%>] *")  ;; Set this to match your custom shell prompt
		;;(setq vterm-shell "zsh")                       ;; Set this to customize the shell to launch
		(setq vterm-max-scrollback 10000))
	(defun efs/configure-eshell ()
		;; Save command history when commands are entered
		(add-hook 'eshell-pre-command-hook 'eshell-save-some-history)

		;; Truncate buffer for performance
		(add-to-list 'eshell-output-filter-functions 'eshell-truncate-buffer)

		;; Bind some useful keys for evil-mode
		(evil-define-key '(normal insert visual) eshell-mode-map (kbd "C-r") 'counsel-esh-history)
		(evil-define-key '(normal insert visual) eshell-mode-map (kbd "<home>") 'eshell-bol)
		(evil-normalize-keymaps)

		(setq eshell-history-size         10000
			eshell-buffer-maximum-lines 10000
			eshell-hist-ignoredups t
			eshell-scroll-to-bottom-on-input t))

	(use-package eshell-git-prompt
		)

	(use-package eshell
		:hook (eshell-first-time-mode . efs/configure-eshell)
		:config

		(with-eval-after-load 'esh-opt
		(setq eshell-destroy-buffer-when-process-dies t)
		(setq eshell-visual-commands '("htop" "zsh" "vim")))

		(eshell-git-prompt-use-theme 'powerline))
(use-package vterm-toggle
	:ensure t
:bind
(("C-`"        . vterm-toggle)
 :map vterm-mode-map
 ("<C-return>" . vterm-toggle-insert-cd))
:config
(add-to-list 'display-buffer-alist
	 '("\*vterm\*"
	 (display-buffer-in-side-window)
	 (window-height . 0.3)
	 (side . bottom)
	 (slot . 0))))

(use-package multiple-cursors
  :ensure t
  :bind (("M-." . mc/mark-next-like-this)
         ("M-," . mc/unmark-next-like-this)
         ("C-S-<mouse-1>" . mc/add-cursor-on-click)))
