(setq inhibit-startup-message t)
(setq package-enable-at-startup nil)
(setq visible-bell t)
(set-keyboard-coding-system nil)
(setq require-final-newline t)
(setq make-back-up-files nil)
(setq x-select-enable-clipboard t)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; Initialize package sources
(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
			 ("org" . "https://orgmode.org/elpa/")
			 ("elpa" . "https://elpa.gnu.org./packages/")))

(package-initialize)
(unless package-archive-contents
  (package-refresh-contents))


;; Initialize use-package on non-Linux platforms
(unless(package-installed-p 'use-package)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)

(column-number-mode)
(global-display-line-numbers-mode)

;; Disable line numbers for some modes
(dolist (mode '(org-mode-hook
		term-mode-hook
		shell-mode-hook
		treemas-mode-hook
		eshell-mode-hook))
  (add-hook mode(lambda () (display-line-numbers-mode 0))))

;(set-face-attribute 'default nil :font "Fira Code Retina" :height efs/default-font-size)
;; Set the fixed pitch face
;(set-face-attribute 'variable-pitch nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the variable pitch face
;(set-face-attribute 'variable-pitch nil :font "Cantarell" :height efs/default-font-size :weight 'regular)

(use-package command-log-mode)

(use-package rainbow-delimiters
	      :hook(prog-mode . rainbow-delimiters-mode))

(use-package which-key
	     :ensure t
	     :init (which-key-mode)
	     :config
	     (setq which-key-idle-delay 0.3))

(use-package ivy
	     :diminish
       	     :bind (("C-s". swiper)
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

(global-set-key (kbd "C-M-j")

(use-package ivy-rich)
 :int
 (ivy-rich-mode 1)

(use-package counsel
	     :bind (("C-M-j" . counsel-switch-buffer)
		    :map minibuffer-local-map
		    ("C-r" . 'counsel-minibuffer-history)
	     :custom
	     (counsel-linux-app-format-function-function #'counsel-linux-app-format-function-name-only)
	     :config
	     (counsel-mode 1)))

(use-package ivy-prescient
	     :after counsel
	     :custom
	     (ivy-prescient-enablee-filtering nil)
	     :config

	     ;;  Uncomment the following line to have sorting remembered across sessions!
	     ;;prescient-persist-mode 1)
	     (ivy-prescient-mode 1))

(use-package helpful
	     :ensure t
	     :custom
	     (counsel-describe-function-function #'helpful-callable)
	     (counsel-describe-variable-function #'helpful-variable)
	     :bind
	     ([remap describe-function] . counsel-descibe-function)
	     ([remap describe-command] . helpful-command)
	     ([remap describe-variable] . counsel-describe-variable)
	     ([remap describe-key] . helpful-key))

(use-package hydra)

(defhydra hydra-text-scale (:timeout 20)
  "scale text"
  ("j" text-scale-increase "in")
  ("k" text-scale-decrease "out")
  ("f" nil "finished" :exit t))

(use-package cl-generic)

;;(require 'exwm-randr)
;;(exwm-randr-enable)
;;(setq exwm-randr-workspace-output-plist '(1 "HDMI-0"))
;;(add-hook 'exwm-randr-screen-change-hook
;;	  (lambda ()
;;	    (start-process-shell-command
;;	     "xrandr" nil "xrandr --output HDMI-0 --left of DP-1 --auto")))
;;(start-process-shell-command "xrandr" nil "xrandr --output Virtual-1 --primary --mode 1600x900 --pos 0x0 --rotate normal")

(require 'exwm-systemtray)
(exwm-systemtray-enable)

;; These keys should always pass through Emacs
(setq exwm-input-prefix-keys
      '(?\C-x
        ?\C-u
	?\C-h
	?\M-x
	?\M-'
	?\M-&
	?\M-:
	?\C-\M-j ;; Buffer list
	?\C-\)) ;;Ctrl+Space

      ;;Ctrl+Q will enable the next key to be sent directly
      (define-key exwm-mode-map [?\C-q] 'exwm-input-send-next-key)
      ([?\s-r] . exwm-reset)

      ;; Move between windows
      ([s-left] . windmove-left)
      ([s-right] . windmove-right)
      ([s-up] . windowmove-up)
      ([-down] . windmove-down)

      ;; Launch application via shell command
      ([?\s-&] . (lambda (command)
		   (interactive (list(read-shell-command "$")))
		   (start-process-shell-command comand nil command)))

      ;; Switch workplace
      ([?\s-w] .exwm-workspace-switch)
      ([?\s-'] . (lambda () (interactive) (exwm-workspace-switch-create 0)))

      ;;'s-N': Switch to certain workspace with Super (Win) plus a number key (0-9)
      ,@(mapcar (lambda (i)
		  '(,(kbd (formaat "s-%d" i))
		    (lambda ()
		      (interactive)
		      (exwm-workspace-switch-create ,i))))
		(number-sequence 0 9 ))))


(use-package exwm)
  :config
  ;; Set the default number of workspaces
  (setq exwm-workspaces-number 5)

  ; When window "class" updates, use it to set the buffer name
  (add-hook 'exwm-update-class-hook #'efs/exwm-update-class)
  ;; Rebind CapsLock to Ctrl
  (start-process-shell-command "xmodmap" nil "xmodmap~/.emacs.d/exwm/Xmodmap")
  
(exwm-enable)
  
(tool-bar-mode -1)
(tooltip-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(set-fringe-mode 10)
(load-theme 'wombat)



  


	     
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(which-key-posframe ivy-rich which-key rainbow-delimiters command-log-mode use-package)))
(custom-set-faces)
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
;; If there is more than one, they won't work right.
