;;; init.el --- Spacemacs Initialization File
;;
;; Copyright (c) 2012-2017 Sylvain Benner & Contributors
;;
;; Author: Sylvain Benner <sylvain.benner@gmail.com>
;; URL: https://github.com/syl20bnr/spacemacs
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; Without this comment emacs25 adds (package-initialize) here
;; (package-initialize)

;; Increase gc-cons-threshold, depending on your system you may set it back to a
;; lower value in your dotfile (function `dotspacemacs/user-config')


;; ---------------------------------------
;; load elscreen
;; ---------------------------------------
;;(setq debug-on-error t)
;; (defun load_elscreen ()
;;   "load elscreen"
;;   (interactive)
;;   (add-to-list 'load-path "~/elscreen")
;;   (load "elscreen" "ElScreen" t)
;;   (elscreen-start)
;;   )

;; (add-to-list 'load-path "~/.emacs.d/elscreen")
;; (require 'elscreen)
;; (elscreen-start)

;; ;; F12 enables elscreen
;; ;;;;(global-set-key (kbd "<f12>") 'load_elscreen)

;; ;; F9 creates a new elscreen, shift-F9 kills it
;; (global-set-key (kbd "<f9>") 'elscreen-create)
;; (global-set-key (kbd "C-c t a b d") 'elscreen-kill)

;; ;; Windowskey+PgUP/PgDown switches between elscreens
;; (global-set-key (kbd "C-M-_") 'elscreen-previous)
;; (global-set-key (kbd "C-M-+") 'elscreen-next)

(setq initial-frame-alist '((top . 0) (left . 0) (width . 100) (height . 80)))
(setenv "PATH" (concat (getenv "PATH") ":/opt/local/bin"))
(setq exec-path (append exec-path '("/opt/local/bin")))

(setq gc-cons-threshold 100000000)
(setq dotspacemacs-install-packages "used-but-keep-unused")
(defconst spacemacs-version          "0.200.9" "Spacemacs version.")
(defconst spacemacs-emacs-min-version   "24.4" "Minimal version of Emacs.")

(if (not (version<= spacemacs-emacs-min-version emacs-version))
    (error (concat "Your version of Emacs (%s) is too old. "
                   "Spacemacs requires Emacs version %s or above.")
           emacs-version spacemacs-emacs-min-version)
  (load-file (concat (file-name-directory load-file-name)
                     "core/core-load-paths.el"))
  (require 'core-spacemacs)
  (spacemacs/init)
  (configuration-layer/sync)
  (spacemacs-buffer/display-startup-note)
  (spacemacs/setup-startup-hook)
  (require 'server)
  (unless (server-running-p) (server-start)))

;; Reveal.js + org-mode
;;(require 'ox-reveal)
;;(setq org-reveal-root "file:///Users/sgurusu/reveal.js")
;;(setq org-reveal-title-slide nil)


(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

;;(setq load-path (cons "~/.emacs.d/elpa/ggtags-20170711.1806/ggtags.el" load-path))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
(add-hook 'python-mode-hook 'anaconda-mode)
(add-hook 'python-mode-hook 'anaconda-eldoc-mode)

(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB work in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t
      helm-echo-input-in-header-line t)

(defun spacemacs//helm-hide-minibuffer-maybe ()
  "Hide minibuffer in Helm session if we use the header line as input field."
  (when (with-helm-buffer helm-echo-input-in-header-line)
    (let ((ov (make-overlay (point-min) (point-max) nil nil t)))
      (overlay-put ov 'window (selected-window))
      (overlay-put ov 'face
                   (let ((bg-color (face-background 'default nil)))
                     `(:background ,bg-color :foreground ,bg-color)))
      (setq-local cursor-type nil))))


(add-hook 'helm-minibuffer-set-up-hook
          'spacemacs//helm-hide-minibuffer-maybe)

(setq helm-autoresize-max-height 0)
(setq helm-autoresize-min-height 20)
(helm-autoresize-mode 1)

(helm-mode 1)


;; INSTALL PACKAGES
;; --------------------------------------

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defvar myPackages
  '(better-defaults
    ein
    elpy
    flycheck
    material-theme
    py-autopep8
    pydoc-info
    info-look
    magit
    ggtags
    nlinum))

(mapc #'(lambda (package)
          (unless (package-installed-p package)
            (package-install package)))
      myPackages)
;; BASIC CUSTOMIZATION
;; --------------------------------------

(setq inhibit-startup-message t) ;; hide the startup message
(load-theme 'material t) ;; load material theme
(global-linum-mode t) ;; enable line numbers globally

;; PYTHON CONFIGURATION
;; --------------------------------------

(elpy-enable)
(setq elpy-rpc-python-command "python3")
(elpy-use-ipython)

;; use flycheck not flymake with elpy
(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

;; enable autopep8 formatting on save
(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

(require 'info-look)

(info-lookup-add-help
 :mode 'python-mode
 :regexp "[[:alnum:]_]+"
 :doc-spec
 '(("(python)Index" nil "")))

(use-package nlinum
  :config
  (global-nlinum-mode))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))

;; ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
              (ggtags-mode 1))))
(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)
(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)

;;ace-window
(windmove-default-keybindings)
(use-package ace-window
  :ensure t
  :init
  (progn
    (global-set-key [remap other-window] 'ace-window)
    ))

;;Org-reveal
(use-package ox-reveal
  :ensure ox-reveal)

(setq org-reveal-root "http://cdn.jsdelivr.net/reveal.js/3.0.0/")
(setq org-reveal-mathjax t)

(use-package htmlize
  :ensure t)

;; eyebrowse
(use-package eyebrowse
  :ensure t
  :config
  (setq eyebrowse-wrap-around t)
  (eyebrowse-mode t)
  (defhydra help/hydra-left-side/eyebrowse (:color blue :hint nil)
    "
current eyebrowse slot: %(eyebrowse--get 'current-slot)
 _j_ previous _k_ last _l_ next _u_ close _i_ choose _o_ rename _q_ quit
   _a_ 00 _s_ 01 _d_ 02 _f_ 03 _g_ 04 _z_ 05 _x_ 06 _c_ 07 _v_ 08 _b_ 09"
    ("j" #'eyebrowse-prev-window-config :exit nil)
    ("k" #'eyebrowse-last-window-config)
    ("l" #'eyebrowse-next-window-config :exit nil)
    ("u" #'eyebrowse-close-window-config :exit nil)
    ("i" #'eyebrowse-switch-to-window-config)
    ("o" #'eyebrowse-rename-window-config :exit nil)
    ("q" nil)
    ("a" #'eyebrowse-switch-to-window-config-0)
    ("s" #'eyebrowse-switch-to-window-config-1)
    ("d" #'eyebrowse-switch-to-window-config-2)
    ("f" #'eyebrowse-switch-to-window-config-3)
    ("g" #'eyebrowse-switch-to-window-config-4)
    ("z" #'eyebrowse-switch-to-window-config-5)
    ("x" #'eyebrowse-switch-to-window-config-6)
    ("c" #'eyebrowse-switch-to-window-config-7)
    ("v" #'eyebrowse-switch-to-window-config-8)
    ("b" #'eyebrowse-switch-to-window-config-9))
  (global-set-key (kbd "C-M-e") #'help/hydra-left-side/eyebrowse/body))


;;rainbow delimeter mode
;; (require 'rainbow-delimiters)
;; (add-hook 'clojure-mode-hook 'rainbow-delimiters-mode)
;; (add-hook 'prog-mode-hook 'rainbow-delimiters-mode)


;; text ++/-- 
(global-set-key (kbd "<C-wheel-up>") 'text-scale-increase)
(global-set-key (kbd "<C-wheel-down>") 'text-scale-decrease)

(global-set-key (kbd "C-c +") 'text-scale-increase)
(global-set-key (kbd "C-c -") 'text-scale-decrease)


(add-to-list 'auto-mode-alist '("\\.plantuml\\'" . plantuml-mode))
(add-to-list
 'org-src-lang-modes '("plantuml" . plantuml))

;; code snippet
(define-key yas-minor-mode-map (kbd "<tab>") nil)
(define-key yas-minor-mode-map (kbd "TAB") nil)
(setq yas-prompt-functions '(yas-x-prompt yas-dropdown-prompt))
(yas-global-mode 1)


(dolist (hook
         '(c-mode-hook
           c++-mode-hook))
  (add-hook hook
            (lambda ()
              (local-set-key (kbd "C-h d")
                             (lambda ()
                               (interactive)
                               (manual-entry (current-word)))))))

;; (add-to-list 'projectile-other-file-alist "(("cpp" "h" "hpp" "ipp")
;;                                             ("ipp" "h" "hpp" "cpp")
;;                                             ("hpp" "h" "ipp" "cpp")
;;                                             ("cxx" "hxx" "ixx")
;;                                             ("ixx" "cxx" "hxx")
;;                                             ("hxx" "ixx" "cxx")
;;                                             ("c" "h")
;;                                             ("m" "h")
;;                                             ("mm" "h")
;;                                             ("h" "c" "cpp" "ipp" "hpp" "m" "mm")
;;                                             ("cc" "hh")
;;                                             ("hh" "cc")
;;                                             ("vert" "frag")
;;                                             ("frag" "vert")
;;                                             (nil "lock" "gpg")
;;                                             ("lock" "")
;;                                             ("gpg" ""))")
