;;; keybindings.el --- Better Emacs Defaults Layer key bindings File
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(add-hook 'notmuch-search-mode-hook
          (lambda()
            (local-set-key (kbd "d") 'notmuch/message-delete)
            (which-key-add-key-based-replacements
              "d" "Delete message")
            (local-set-key (kbd "a") 'notmuch/message-archive)
            (which-key-add-key-based-replacements
              "a" "Archive message")
            (local-set-key (kbd "C-c r") 'notmuch/message-receipt-archive)
            (which-key-add-key-based-replacements
              "C-c r" "Tag as receipt, archive")))

(add-hook 'message-mode-hook
          (lambda()
            (local-set-key (kbd "C-c i") 'notmuch/select-identity)
            (which-key-add-key-based-replacements
              "C-c i" "Select mail identity")))

