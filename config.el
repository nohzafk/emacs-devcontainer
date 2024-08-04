(use-package! lsp-bridge
  :config

  ;; for muscle memory to save buffer
  (defun my/save-buffer ()
  (interactive)
  (if lsp-bridge-remote-file-flag
      (call-interactively #'lsp-bridge-remote-save-buffer)
    (call-interactively #'save-buffer)))

  (map! "C-x C-s" #'my/save-buffer))

(use-package! flymake-bridge
  :after lsp-bridge
  :hook (lsp-bridge-mode . flymake-bridge-setup))

(map! :after flymake
      "M-n" #'flymake-goto-next-error
      "M-p" #'flymake-goto-prev-error)

(after! tramp
  (add-to-list 'tramp-remote-path "~/.nix-profile/bin")
  (add-to-list 'tramp-remote-path 'tramp-own-remote-path))

(use-package! apheleia
  :after lsp-bridge
  :config
  ;; don't mess up with lsp-mode
  (setq +format-with-lsp nil)
  (setq apheleia-remote-algorithm 'remote))

(use-package! topsy
  :after lsp-bridge
  :config
  ;; display a bar to remind editing remote file
  (setcdr (assoc nil topsy-mode-functions)
          (lambda ()
            (when (lsp-bridge-is-remote-file) "[LBR] REMOTE FILE")))

  ;; do not activate when the current major mode is org-mode
  (add-hook 'lsp-bridge-mode-hook (lambda ()
                                    (unless (derived-mode-p 'org-mode)
                                      (topsy-mode 1)))))

(after! vterm
  (defun my/set-vterm-shell ()
    (when (string-prefix-p "/docker:" (file-remote-p default-directory))
      (when (eq major-mode 'vterm-mode)
        (let ((shell (if (string-prefix-p "/docker:" (file-remote-p default-directory))
                         "/bin/bash"
                       (or (getenv "SHELL") "/bin/bash"))))
          (vterm-send-string (format "exec %s\n" shell))
          (vterm-send-string "clear\n")))))

  (add-hook 'vterm-mode-hook #'my/set-vterm-shell))
