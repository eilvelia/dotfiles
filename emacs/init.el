(require 'package)
(setq package-archives
      '(("GNU ELPA"     . "https://elpa.gnu.org/packages/")
        ("MELPA Stable" . "https://stable.melpa.org/packages/")
        ("MELPA"        . "https://melpa.org/packages/"))
      package-archive-priorities
      '(("GNU ELPA"     . 10)
        ("MELPA Stable" . 5)
        ("MELPA"        . 0)))
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(unless (package-installed-p 'diminish)
  (package-install 'diminish))

(eval-when-compile
  (require 'use-package))
(require 'diminish)

(setq initial-frame-alist '((top . 120) (left . 280)))

(setq default-frame-alist '((width . 100) (height . 40)))

(add-to-list 'default-frame-alist '(font . "Menlo-13"))
(set-face-attribute 'default t :font "Menlo-13")

(tool-bar-mode -1)

(setq inhibit-splash-screen t)

(delete-selection-mode 1)

(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)

(setq-default show-trailing-whitespace t)

(setq echo-keystrokes 0.1)
(setq eldoc-idle-delay 0.2)

(setq column-number-mode t)

(when (version<= "26.1" emacs-version)
  (global-display-line-numbers-mode)
  ;; (setq display-line-numbers-width-start t)
  (setq display-line-numbers-grow-only t)
  )

(setq make-backup-files nil)

(global-unset-key (kbd "s-D"))
(global-set-key (kbd "C-S-D") 'dired)

(global-set-key (kbd "s-<up>") 'beginning-of-buffer)
(global-set-key (kbd "s-<down>") 'end-of-buffer)

(global-set-key (kbd "s-/") 'comment-line)

(global-set-key (kbd "s-X") 'execute-extended-command)

(global-set-key (kbd "s-<return>") 'electric-indent-just-newline)

(global-unset-key (kbd "<s-left>"))
(global-unset-key (kbd "<s-right>"))
(global-set-key (kbd "<M-s-left>") 'ns-prev-frame)
(global-set-key (kbd "<M-s-right>") 'ns-prev-frame)
(global-set-key (kbd "<s-right>") 'move-end-of-line)
(global-set-key (kbd "<s-left>") 'move-beginning-of-line)

(global-set-key (kbd "s-r") 'delete-trailing-whitespace)

(global-unset-key (kbd "s-d"))

(global-unset-key (kbd "s-p"))

(defun duplicate-line (arg)
  (interactive "*p")
  (setq buffer-undo-list (cons (point) buffer-undo-list))
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion
      (end-of-line)
      (setq eol (point))
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        (while (> count 0)
          (newline)
          (insert line)
          (setq count (1- count)))
        )
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    )
  (next-line arg))

(global-set-key (kbd "s-D") 'duplicate-line)

(defmacro save-column (&rest body)
  `(let ((column (current-column)))
     (unwind-protect
         (progn ,@body)
       (move-to-column column))))
(put 'save-column 'lisp-indent-function 0)

(defun move-line-up ()
  (interactive)
  (save-column
    (transpose-lines 1)
    (forward-line -2)))

(defun move-line-down ()
  (interactive)
  (save-column
    (forward-line 1)
    (transpose-lines 1)
    (forward-line -1)))

(global-set-key (kbd "M-<up>") 'move-line-up)
(global-set-key (kbd "M-<down>") 'move-line-down)

(use-package one-themes
  :ensure t
  :init
  (load-theme 'one-dark t))

(use-package company
  :ensure t
  :bind (
         :map company-active-map
         ("<tab>" . company-complete-selection)
         ("TAB" . company-complete-selection)
         ("SPC" . nil)

         :map company-active-map
         :filter (company-explicit-action-p)
         ("<return>" . company-complete-selection)
         ("RET" . company-complete-selection)
         )
  :config
  (setq company-dabbrev-downcase 0.3)
  (setq company-idle-delay 0.3)
  (add-to-list 'company-backends 'merlin-company-backend)
  (add-hook 'after-init-hook 'global-company-mode))

(use-package auto-complete :ensure t)

(use-package markdown-mode
  :ensure t
  :commands (markdown-mode gfm-mode)
  :mode (("README\\.md\\'" . gfm-mode)
         ("\\.md\\'" . markdown-mode)
         ("\\.markdown\\'" . markdown-mode))
  :init (setq markdown-command "multimarkdown"))

(use-package tuareg
  :ensure t
  :init
  (face-spec-set
   'tuareg-font-lock-constructor-face
   '((((class color) (background light)) (:foreground "SaddleBrown"))
     (((class color) (background dark)) (:foreground "burlywood1"))))
  :config
  (setq tuareg-interactive-program "utop"))

(use-package merlin
  :ensure t
  :hook (
         (tuareg-mode . merlin-mode)
         (merlin-mode . company-mode)
         (tuareg-mode . merlin-eldoc-setup)
         )
  :config
  (let ((opam-share (ignore-errors
                      (car (process-lines "opam" "config" "var" "share")))))
    (when (and opam-share (file-directory-p opam-share))
      (add-to-list 'load-path (expand-file-name "emacs/site-lisp" opam-share))
      ))
  :custom
  (eldoc-echo-area-use-multiline-p t)
  (merlin-eldoc-max-lines-type 4)
  (merlin-eldoc-type-verbosity 'min)
  )

(use-package org :ensure t :defer t)

(use-package magit :ensure t)

(use-package projectile
  :ensure t
  :config
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (projectile-mode +1)
  )

(use-package web-mode
  :ensure t
  :mode (
         ("\\.phtml\\'" . web-mode)
         ("\\.tpl\\.php\\'" . web-mode)
         ("\\.[agj]sp\\'" . web-mode)
         ("\\.as[cp]x\\'" . web-mode)
         ("\\.erb\\'" . web-mode)
         ("\\.mustache\\'" . web-mode)
         ("\\.djhtml\\'" . web-mode)
         ("\\.html?\\'" . web-mode))
  :custom
  (web-mode-markup-indent-offset 2)
  (web-mode-css-indent-offset 2)
  (web-mode-code-indent-offset 2)
  (web-mode-css-offset 2)
  (web-mode-script-offset 2)
  (web-mode-enable-current-element-highlight t)
  (web-mode-ac-sources-alist
   '(("css" . (ac-source-css-property))
     ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
  )

(use-package yaml-mode
  :ensure t
  :mode (("\\.ya?ml\\'" . yaml-mode))
  )

(use-package highlight-indent-guides
  :ensure t
  :diminish highlight-indent-guides-mode
  :hook (prog-mode . highlight-indent-guides-mode)
  :custom
  (highlight-indent-guides-method 'character)
  ;; (highlight-indent-guides-responsive 'top) ; slows down emacs :(
  ;; (highlight-indent-guides-delay 0)
  )

(use-package multiple-cursors
  :ensure t
  :config
  (global-set-key (kbd "<C-s-left>") 'mc/edit-lines)
  (global-set-key (kbd "<M-s-down>") 'mc/mark-next-like-this)
  (global-set-key (kbd "s-d") 'mc/mark-next-like-this)
  (global-set-key (kbd "<M-s-up>") 'mc/mark-previous-like-this)
  ;; (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
  )

;; From http://anirudhsasikumar.net/blog/2005.01.21.html
(define-minor-mode sensitive-mode
  "Disables backup creation and auto saving"
  nil
  " Sensitive"
  nil
  (if (symbol-value sensitive-mode)
      (progn
        (set (make-local-variable 'backup-inhibited) t)
        (if auto-save-default
            (auto-save-mode -1)))
    (kill-local-variable 'backup-inhibited)
    (if auto-save-default
        (auto-save-mode 1))))

(setq auto-mode-alist
      (append '(("\\.gpg$" . sensitive-mode))
              auto-mode-alist))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t)
 '(package-selected-packages
   (quote
    (highlight-indent-guides magit merlin-eldoc merlin auto-complete markdown-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
