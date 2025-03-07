;;; init.el --- Some summary -*- lexical-binding: t -*-

;; This file is not part of GNU Emacs

;;; Commentary:

;; My commentary

;;; Code:

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(all-the-icons command-log-mode company concurrent counsel ctable
                   deferred docker dockerfile-mode doom-modeline
                   doom-themes elpa-mirror epc flycheck go-mode
                   hcl-mode hl-todo lsp-ivy lsp-pyright lsp-treemacs
                   lsp-ui magit mu4e notmuch org-bullets
                   outline-indent rust-mode solaire-mode undo-fu
                   vc-use-package yaml-mode yaml-pro))
 '(package-vc-selected-packages
   '((dockerfile-mode :vc-backend Git :url
                      "https://github.com/aogier/dockerfile-mode")
     (vc-use-package :vc-backend Git :url
                     "https://github.com/slotThe/vc-use-package"))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrainsMono Nerd Font" :foundry "JB" :slant normal :weight regular :height 120 :width normal)))))
;; ;;(set-face-attribute 'default nil
		    ;;:font "JetBrainsMono Nerd Font" :height 120

		    ;;)

(setq inhibit-startup-message t)

(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)

(menu-bar-mode -1)

;; (setq visible-bell t)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)
(add-hook 'prog-mode-hook (lambda () (setq indent-tabs-mode nil)))
(add-hook 'prog-mode-hook (lambda () (setq column-number-mode t)))
(add-hook 'prog-mode-hook (lambda () (setq tab-width 4)))

(setq column-number-mode t)
(setq line-number-mode t)


(load-theme 'wombat)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;;(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ;;("melpa-stable" . "https://stable.melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


(require 'use-package)
(setq use-package-always-ensure t)

(unless (package-installed-p 'vc-use-package)
  (package-vc-install "https://github.com/slotThe/vc-use-package"))
(require 'vc-use-package)


(use-package command-log-mode
  :diminish)

(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
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

(use-package counsel
  :diminish
  :bind (("M-x" . counsel-M-x)
	     ("C-x b" . counsel-ibuffer)
	     ("C-x C-f" . counsel-find-file)
	     :map minibuffer-local-map
	     ("C-r" . 'counsel-minibuffer-history))
  :config
  (setq ivy-initial-inputs-alist nil))

;;; UNDO
;; Vim style undo not needed for emacs 28
(use-package undo-fu)


;;;;evil
;;(use-package evil
;;  :demand t
;;  :bind (("<escape>" . keyboard-escape-quit))
;;  :init
;;  ;; allows for using cgn
;;  ;; (setq evil-search-module 'evil-search)
;;  (setq evil-want-keybinding nil)
;;  ;; no vim insert bindings
;;  (setq evil-undo-system 'undo-fu)
;;  ;; org mode fix https://jeffkreeftmeijer.com/emacs-evil-org-tab/
;;  (setq evil-want-C-i-jump nil)
;;  :config
;;  (evil-mode 1)
;;  (setq evil-normal-state-cursor '(box "light blue")
;;      evil-insert-state-cursor '(box "orange")
;;      evil-replace-state-cursor '(box "red")
;;      evil-visual-state-cursor '(hollow "orange"))
;;  )


(use-package company
   :hook (prog-mode . company-mode)
   :config
   ;; https://github.com/company-mode/company-mode/discussions/1356
   (define-key company-active-map [escape] 'company-abort)

   ;; https://github.com/jadestrong/lsp-proxy?tab=readme-ov-file#company-and-corfu
   (setq company-idle-delay 0)

   ;; If you encounter issues when typing Vue directives (e.g., v-), you can try setting it to 1. I'm not sure if it's a problem with Volar.
   (setq company-minimum-prefix-length 2)
   (setq company-tooltip-idle-delay 0)

  ;; (setq company-idle-delay nil  ;; works as expected, completion is not invoked
  ;;       company-semantic-begin-after-member-access nil  ;; still pops-up, no change :(
  ;;       company-clang-begin-after-member-access nil     ;; no change either :(
  ;;       company-minimum-prefix-length 3
  ;;       company-selection-wrap-length 1
  ;;       company-selection-wrap-around t)
  ) ;; invokes completion manually

(global-set-key (kbd "C-SPC") 'company-complete)


(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-inlay-hints-enable t)
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration)
         ;; ;; https://github.com/emacs-lsp/lsp-mode/issues/4357#issuecomment-1986856407
         (lsp-register-custom-settings
          '(("gopls.hints" ((assignVariableTypes . t)
                            (compositeLiteralFields . t)
                            (compositeLiteralTypes . t)
                            (constantValues . t)
                            (functionTypeParameters . t)
                            (parameterNames . t)
                            (rangeVariableTypes . t)))))
)
  :commands lsp
  )
;; optionally
(use-package lsp-ui :commands lsp-ui-mode)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
(use-package lsp-treemacs :commands lsp-treemacs-errors-list)
;; optional if you want which-key integration
(use-package which-key
  :init
  (setq which-key-idle-delay 0.5)
  :config
  (which-key-mode))


(defun lsp-booster--advice-json-parse (old-fn &rest args)
  "Try to parse bytecode instead of json."
  (or
   (when (equal (following-char) ?#)
     (let ((bytecode (read (current-buffer))))
       (when (byte-code-function-p bytecode)
         (funcall bytecode))))
   (apply old-fn args)))
(advice-add (if (progn (require 'json)
                       (fboundp 'json-parse-buffer))
                'json-parse-buffer
              'json-read)
            :around
            #'lsp-booster--advice-json-parse)

(defun lsp-booster--advice-final-command (old-fn cmd &optional test?)
  "Prepend emacs-lsp-booster command to lsp CMD."
  (let ((orig-result (funcall old-fn cmd test?)))
    (if (and (not test?)                             ;; for check lsp-server-present?
             (not (file-remote-p default-directory)) ;; see lsp-resolve-final-command, it would add extra shell wrapper
             lsp-use-plists
             (not (functionp 'json-rpc-connection))  ;; native json-rpc
             (executable-find "emacs-lsp-booster"))
        (progn
          (when-let ((command-from-exec-path (executable-find (car orig-result))))  ;; resolve command from exec-path (in case not found in $PATH)
            (setcar orig-result command-from-exec-path))
          (message "Using emacs-lsp-booster for %s!" orig-result)
          (cons "emacs-lsp-booster" orig-result))
      orig-result)))
(advice-add 'lsp-resolve-final-command :around #'lsp-booster--advice-final-command)

(use-package go-mode
  :defer t
  )
(add-hook 'go-mode-hook 'lsp-deferred)
(setq gofmt-command "goimports")
(add-hook 'before-save-hook 'gofmt-before-save)

(add-hook 'before-save-hook 'lsp-format-buffer)
(add-hook 'before-save-hook 'lsp-organize-imports)

(use-package rust-mode
  :defer t
  :init
  (setq rust-mode-treesitter-derive t)
  )
;;(require 'rust-mode)

(add-hook 'rust-mode-hook
          (lambda () (setq indent-tabs-mode nil)))
(setq rust-format-on-save t)
(add-hook 'rust-mode-hook #'lsp)


(use-package dockerfile-mode
  :vc (:repo aogier/dockerfile-mode
	    :fetcher github))

(use-package docker
  :bind ("C-c d" . docker))


(use-package yaml-mode)

(use-package yaml-pro)
(add-hook 'yaml-mode-hook 'yaml-pro-ts-mode 100)


(use-package flycheck
  :init (global-flycheck-mode)
  :config (add-hook 'after-init-hook #'global-flycheck-mode)
  )


(use-package lsp-pyright
  :custom (lsp-pyright-langserver-command "basedpyright") ;; or basedpyright
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))  ; or lsp-deferred

(use-package all-the-icons
  :if (display-graphic-p))

(use-package solaire-mode)
(solaire-global-mode +1)

(use-package doom-themes
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-one t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  (doom-themes-neotree-config)
  ;; or for treemacs users
  (setq doom-themes-treemacs-theme "doom-atom") ; use "doom-colors" for less minimal icon theme
  (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15)))

(use-package elpa-mirror)

;; org

(setq org-hide-emphasis-markers t)
(use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))
;; (let* ((variable-tuple
;;           (cond ((x-list-fonts "ETBembo")         '(:font "ETBembo"))
;;                 ((x-list-fonts "Source Sans Pro") '(:font "Source Sans Pro"))
;;                 ((x-list-fonts "Lucida Grande")   '(:font "Lucida Grande"))
;;                 ((x-list-fonts "Verdana")         '(:font "Verdana"))
;;                 ((x-family-fonts "Sans Serif")    '(:family "Sans Serif"))
;;                 (nil (warn "Cannot find a Sans Serif Font.  Install Source Sans Pro."))))
;;          (base-font-color     (face-foreground 'default nil 'default))
;;          (headline           `(:inherit default :weight bold :foreground ,base-font-color)))

;;     (custom-theme-set-faces
;;      'user
;;      `(org-level-8 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-7 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-6 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-5 ((t (,@headline ,@variable-tuple))))
;;      `(org-level-4 ((t (,@headline ,@variable-tuple :height 1.1))))
;;      `(org-level-3 ((t (,@headline ,@variable-tuple :height 1.25))))
;;      `(org-level-2 ((t (,@headline ,@variable-tuple :height 1.5))))
;;      `(org-level-1 ((t (,@headline ,@variable-tuple :height 1.75))))
;;      `(org-document-title ((t (,@headline ,@variable-tuple :height 2.0 :underline nil))))))

(global-auto-revert-mode 1)
(use-package outline-indent
  :ensure t
  :custom
  (outline-indent-ellipsis " ▼ "))

;; Python
(add-hook 'python-mode-hook #'outline-indent-minor-mode)
(add-hook 'python-ts-mode-hook #'outline-indent-minor-mode)

;; YAML
;; (add-hook 'yaml-mode-hook #'outline-indent-minor-mode)
(add-hook 'yaml-ts-mode-hook #'outline-indent-minor-mode)


(add-hook 'before-save-hook 'delete-trailing-whitespace)

;; https://stackoverflow.com/questions/151945/how-do-i-control-how-emacs-makes-backup-files
(setq backup-directory-alist `(("." . "~/.saves")))
(setq backup-by-copying t)
(setq delete-old-versions t
  kept-new-versions 6
  kept-old-versions 2
  version-control t)



(global-auto-revert-mode 1)


(use-package magit)

(setq require-final-newline t)
(global-display-line-numbers-mode 1)

; lsp-doctor
(setq gc-cons-threshold 100000000)

(setq read-process-output-max (* 1024 1024)) ;; 1mb

(setq vc-follow-symlinks t)

;; https://www.reddit.com/r/emacs/comments/bwt79w/how_to_make_companylsp_noncasesensitive/
(setq completion-ignore-case t)



(global-set-key (kbd "M-o") 'ace-window)
(global-set-key [f9] 'sort-lines)



;; https://www.reddit.com/r/emacs/comments/f8tox6/todo_highlighting/
(use-package hl-todo
       ;; :custom-face
       ;; (hl-todo ((t (:inherit hl-todo :italic t))))
       :hook ((prog-mode . hl-todo-mode)
              (yaml-mode . hl-todo-mode)))

(use-package hcl-mode)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((python . t)))
(setq org-babel-python-command "python3")


;; https://www.reddit.com/r/emacs/comments/10l40yi/comment/j5vf76p/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
(defun +keyboard-escape-quit-adv (fun)
"Around advice for `keyboard-escape-quit' FUN.
 Preserve window configuration when pressing ESC."
(let ((buffer-quit-function (or buffer-quit-function #'keyboard-quit)))
  (funcall fun)))
(advice-add #'keyboard-escape-quit :around #'+keyboard-escape-quit-adv)


;;; init.el ends here
