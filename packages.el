(when (package! lsp-bridge
        :recipe (:host github
                 :repo "manateelazycat/lsp-bridge"
                 :branch "master"
                 :files ("*.el" "*.py" "acm" "core" "langserver" "multiserver" "resources")
                 :build (:not compile)))
  ;; doom-emacs has mardown-mode
  ;; (package! markdown-mode)
  (package! yasnippet)
  (package! topsy)
  (package! flymake-bridge
    :recipe (:host github :repo "liuyinz/flymake-bridge" :branch "master")))
