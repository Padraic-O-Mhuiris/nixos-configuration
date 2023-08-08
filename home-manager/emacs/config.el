(setq user-full-name "Patrick Morris"
      user-mail-address "patrick.morris.310@gmail.com")

(setq doom-font (font-spec :family "Iosevka" :size 16)
      doom-big-font (font-spec :family "Iosevka" :size 24))

(setq doom-theme 'doom-nord-light)
(setq +doom-dashboard-menu-sections nil)
(setq doom-modeline-enable-word-count t)

(setq auto-save-default t)

;; (setq tab-width 2)
;; (setq standard-indent 2)

;; (setq-hook! js2-mode-hook js-indent-level 2)
;; (setq-hook! typescript-mode-hook typescript-indent-level 2)

;; (after! typescript-mode
;;   (setq typescript-indent-level 2))

;; (setq org-directory "~/.org")
;; (setq org-roam-directory "~/.org")
;; (setq org-roam-db-location "~/.org/org-roam.db")
;; (setq org-roam-v2-ack t)

;; (setq time-stamp-active t
;;       time-stamp-start "#\\+LAST_MODIFIED:[ \t]*"
;;       time-stamp-end "$"
;;       time-stamp-format "\[%Y-%m-%d %a %H:%M:%S\]")

;; (add-hook 'before-save-hook 'time-stamp nil)

;; (setq flycheck-solidity-solium-soliumrcfile "$SOLHINT_PATH")

;; (after! org
;;   (setq org-directory "~/docs/notes"
;;         org-agenda-files (directory-files-recursively "~/docs/notes/" "\\.org$")
;;         +org-capture-todo-file "inbox.org")
;;   (setq org-hierarchical-todo-statistics t)
;;   (setq org-archive-location "~/docs/notes/archive/%s_archive::* Archived Tasks")

;;   ;; org-agenda
;;   (setq org-todo-keywords '
;;         ((sequence
;;           "TODO(t)"
;;           "IDEA(i)"
;;           "PROJECT(p)"
;;           "|"
;;           "DONE(d)"
;;           "CANCELLED(c)")))

;;   ;; org-roam
;;   (setq org-roam-directory (file-truename "~/docs/notes"))
;;   (setq org-roam-capture-templates
;;         '(("d" "default" plain "%?" :target
;;            (file+head "%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
;;            :unnarrowed t
;;            :jump-to-captured t)
;;           ("b" "blog" plain "%?" :target)))
;;   (setq org-roam-dailies-directory "dailies/")
;;   (setq org-roam-dailies-capture-templates
;;         '(("d" "default" entry
;;            "* %<%H:%M>\n %?"
;;            :target (file+head "%<%Y-%m-%d>.org"
;;                               "#+title: %<%Y-%m-%d>\n")
;;            :empty-lines-after 1
;;            :empty-lines-before 1)))
;;   (org-roam-db-autosync-mode))



;;   (setq org-todo-keywords
;;       '((sequence "TODO" "IDEA" "GOAL" "PROJECT" "|" "DONE" "CANCELLED")))

;;   (setq org-format-latex-options (plist-put org-format-latex-options :scale 0.9)))

;; (after! evil-org-agenda
;;   (setq org-agenda-files (directory-files-recursively "~/.org/" "\\.org$")))


;; (setq org-download-screenshot-method  "flameshot gui --raw > %s")
;; (setq ledger-post-amount-alignment-column 100)
;; (setq ledger-post-account-alignment-column 2)

;; (setq all-the-icons-scale-factor 1.1)
;; (setq solidity-flycheck-solc-checker-active t)

;; (setq beancount-number-alignment-column 100)
;; (setq beancount-account-chars 60)

;; (add-hook 'beancount-mode-hook #'outline-minor-mode)
