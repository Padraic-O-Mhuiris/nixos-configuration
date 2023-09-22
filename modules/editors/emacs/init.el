;; Remove uneeded UI elements
(setq inhibit-startup-message t)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(tooltip-mode -1)
(set-fringe-mode 10)
(menu-bar-mode -1)
(setq visible-bell t)

;; Font
(set-face-attribute 'default nil :font "Iosevka NFM" :height 100)

;; User configuration
(setq user-full-name "Patrick H Morris"
      user-mail-address "patrick.morris.310@gmail.com")

;; use-package
(setq use-package-always-ensure t)

;; Line-numbers
(column-number-mode)
(global-display-line-numbers-mode t)

(dolist (mode '(org-mode-hook
                term-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))

;; #############################################################################
;; general.el
;; #############################################################################
(use-package general
  :config
  (general-evil-setup t)

  (general-define-key
   "<escape>" 'keyboard-escape-quit
   "C-c t" 'clm/toggle-command-log-buffer
   "C-M-j" 'counsel-switch-buffer)

  (general-create-definer pm/leader-key-def
    :keymaps '(normal insert visual emacs)
    :prefix "SPC"
    :global-prefix "C-SPC")

  (pm/leader-key-def
   "t" '(:ignore t :which-key "toggles")
   "tt" '(counsel-load-theme :which-key "choose theme")))

;; #############################################################################
;; evil
;; #############################################################################
(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; #############################################################################
;; hydra
;; #############################################################################
(use-package hydra)

(defhydra hydra-text-scale (:timeout 4)
  "scale text"
  ("+" text-scale-increase "+")
  ("-" text-scale-decrease "-")
  ("f" nil "finished" :exit t))

(pm/leader-key-def
 "ts" '(hydra-text-scale/body :which-key "scale text"))

;; #############################################################################
;; doom-modeline
;; #############################################################################
(use-package doom-modeline
  :init (doom-modeline-mode 1)
  :custom ((doom-modeline-height 15))
  :config
  (use-package all-the-icons))

;; #############################################################################
;; doom-themes
;; #############################################################################
(use-package doom-themes
  :config
  (setq doom-themes-enable-bold t    ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-moonlight t)
  (doom-themes-visual-bell-config)
  (doom-themes-org-config))

;; #############################################################################
;; ivy
;; #############################################################################
(use-package ivy
  :diminish
  :config
  (ivy-mode 1)

  (use-package ivy-rich
    :init (ivy-rich-mode 1)))

;; #############################################################################
;; counsel
;; #############################################################################
(use-package counsel
  :bind (("M-x" . counsel-M-x))
  ("C-x b" . counsel-ibuffer)
  :map minibuffer-local-map
  ("C-r" . 'counsel-minibuffer-history
   :config
   (setq ivy-initial-inputs-alist nil)))


;; #############################################################################
;; command-log-mode
;; #############################################################################
(use-package command-log-mode
  :diminish
  :config (global-command-log-mode)
  :bind (("C-c t" . clm/toggle-command-log-buffer)))

;; #############################################################################
;; which-key
;; #############################################################################
(use-package which-key
  :diminish which-key-mode
  :init (which-key-mode)
  :config
  (setq which-key-idle-delay 0))

;; #############################################################################
;; rainbow-delimiters
;; #############################################################################
(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

;; #############################################################################
;; helpful
;; #############################################################################
(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))


;; #############################################################################
;; projectile
;; #############################################################################
(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/code")
    (setq projectile-project-search-path '("~/code")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :after projectile
  :config (counsel-projectile-mode))

;; #############################################################################
;; magit
;; #############################################################################
(use-package magit
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

;; #############################################################################
;; org
;; #############################################################################
(use-package org)
