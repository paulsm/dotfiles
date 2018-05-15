(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
		    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(defcustom cider-lein-parameters
  "repl :headless :host localhost"
  "Params passed to Leiningen to start an nREPL server via `cider-jack-in'."
  :type 'string
  :group 'cider
  :safe #'stringp)

;; No menu bar
(menu-bar-mode -1)

;; Org mode customizations
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/tasks.org"))


;; Additional paths
(add-to-list 'load-path
	     "~/.emacs.d/lib")
(add-to-list 'package-archives
	     '("melpa-stable" . "http://melpa-stable.milkbox.net/packages/"))
(add-to-list 'package-archives
	     '("melpa" . "http://melpa.milkbox.net/packages/"))
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Initialize all the ELPA packages (what is installed using the packages commands)
(package-initialize)

;; Display theme
(load-theme 'leuven)
;;(load-theme 'solarized-dark)
;;(load-theme 'monokai)

;; Set bigger fonts
(set-default-font "WANdiscoPro-14")
(set-frame-font "WANdiscoPro-14")
(add-to-list 'default-frame-alist '(font . "WANdiscoPro-14"))
(set-face-attribute 'default t :font "WANdiscoPro-14")

;; Clojure
(add-hook 'clojure-mode-hook 'turn-on-eldoc-mode)
(add-hook 'clojure-mode-hook 'paredit-mode)
(show-paren-mode 1)
;;(global-rainbow-delimiters-mode)
(setq nrepl-popup-stacktraces nil)
(add-to-list 'same-window-buffer-names "<em>nrepl</em>")

;; (add-hook 'after-init-hook 'global-company-mode)

;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; Enter cider mode when entering the clojure major mode
(add-hook 'clojure-mode-hook 'cider-mode)

;; Turn on auto-completion with Company-Mode
;; (global-company-mode)
(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)

;; Replace return key with newline-and-indent when in cider mode.
(add-hook 'cider-mode-hook '(lambda () (local-set-key (kbd "RET") 'newline-and-indent)))

;; Rainbow delimiters
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

;; Leiningen
(setq exec-path (append exec-path '("~/bin")))

;; Helm-ag
;; Make sure to have Platinum Searcher installed: https://github.com/monochromegane/the_platinum_searcher
(setq exec-path (append exec-path '("/usr/local/bin")))
(global-set-key (kbd "M-s") 'helm-do-ag)

; Syntax Highlighting
(require 'highlight-symbol)
(global-set-key (kbd "C-é") 'highlight-symbol-at-point)
(global-set-key (kbd "C-.") 'highlight-symbol-next)
(global-set-key (kbd "C-,") 'highlight-symbol-prev)
(global-set-key (kbd "C-;") 'highlight-symbol-query-replace)

;; Exec path from shell
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

;; Personal custom key bindings
(setq compilation-read-command nil)
;;(global-set-key (kbd "C-c C-c") 'compile)

(defun bury-compile-buffer-if-successful (buffer string)
 "Bury a compilation buffer if succeeded without warnings "
 (when (and
	(buffer-live-p buffer)
	(string-match "compilation" (buffer-name buffer))
	(string-match "finished" string)
	(not
	 (with-current-buffer buffer
	   (goto-char (point-min))
	   (search-forward "warning" nil t))))
   (run-with-timer 1 nil
		   (lambda (buf)
		     (bury-buffer buf)
		     (switch-to-prev-buffer (get-buffer-window buf) 'kill))
		   buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

;; Minimize dired
(require 'ls-lisp)
(setq ls-lisp-use-insert-directory-program nil)

;; 80 columns
(setq-default fill-column 79)

;; Magit
(global-set-key (kbd "C-x g") 'magit-status)

;; Backups in sane location
(setq backup-directory-alist `(("." . "~/.emacs.d/saves")))

;; Org mode
(require 'org)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)
(setq org-agenda-files (list "~/org/tasks.org"))

;; Random global keys
;;(global-set-key (kbd "C-h") 'delete-backward-char)

;; Testing
(global-set-key (kbd "C-,") 'beginning-of-buffer)
