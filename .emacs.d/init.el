;; auto-install
;; http://www.emacswiki.org/emacs/auto-install.el
;; (require 'auto-install)
;; (auto-install-update-emacswiki-package-name t)
;; (auto-install-from-emacswiki "auto-install.el")
(add-to-list 'load-path "~/.emacs.d/auto-install")

;; package.el
;; (auto-install-from-url "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el")
;; (add-to-list 'package-archives '("marmalade" . "http://marmalade-repo.org/packages/"))
(require 'package)
(package-initialize)
(package-activate 'magit '(1 1 1))
(package-activate 'auto-complete '(1 4))

;; init loader
;; http://coderepos.org/share/browser/lang/elisp/init-loader/init-loader.el
(eval-when-compile (require 'cl))
(defvar init-loader-directory (expand-file-name "~/.emacs.d/conf"))
(defvar init-loader-regexp "\\(?:^[[:digit:]]\\{2\\}-.*\.elc?\\)$")
(defun init-loader-files (dir regexp)
  (let ((common-files (directory-files dir t))
        (window-files (directory-files (mapconcat 'identity (list init-loader-directory "window" (symbol-name window-system)) "/") t)))
    (loop for file in (append common-files window-files)
          when (and (string-match regexp (file-name-nondirectory file))
                    (or (not (locate-library (concat file "c")))
                        (string-match "\.elc$" file)))
          collect file into ret
          finally return (sort ret 'string<))))
(defun init-loader-load (dir regexp)
  (dolist (target (init-loader-files dir regexp))
    (condition-case e
        (load (file-name-sans-extension target) nil t)
      (error (message "load error: %s - %s" target e)))))
(init-loader-load init-loader-directory init-loader-regexp)

;; after init
(add-hook 'after-init-hook
  (lambda ()
    ;; split window
    ;; (split-window-horizontally)
    ;; show init time
    (message "init time: %.3f sec"
             (float-time (time-subtract after-init-time before-init-time)))))
