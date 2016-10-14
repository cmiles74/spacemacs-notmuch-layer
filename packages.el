;;; packages.el --- notmuch Layer packages File for Spacemacs
;;
;; Copyright (c) 2014-2015 Sylvain Benner & Contributors
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

;; List of all packages to install and/or initialize. Built-in packages
;; which require an initialization must be listed explicitly in the list.
(setq notmuch-packages
      '(notmuch
        gnus-alias
        org))

;;
;; Sensible default settings
;;

;; colors of tags and unread messages
(setq notmuch/notmuch-tag-face-color-default "#3f7f5f")
(setq notmuch/notmuch-search-unread-face-color-default "#4f97d7")

;; position of quoted messages
(setq notmuch/message-cite-reply-position-default 'above)
(setq notmuch/address-lookup-bin-default "notmuch-addrlookup")

;; after a message is sent, kill the buffer
(setq message-kill-buffer-on-exit t)

;; add the from address when sending messages
(setq mail-specify-envelope-from t)
(setq message-sendmail-envelope-from 'header)
(setq mail-envelope-from 'header)

;; identities
(setq notmuch/gnus-alias-identities-default ())
(setq notmuch/gnus-alias-identity-rules-default ())

(defun notmuch/init-notmuch ()
  "Initialize Notmuch"  
  (use-package notmuch
    :defer t
    :init
    (progn
      (evil-leader/set-key
        "an" 'notmuch)
      )
    :config
    (progn
      ;; customize colors
      (set-face-attribute 'notmuch-tag-face nil
                          :foreground notmuch/notmuch-tag-face-color
                          :bold nil)
      (set-face-attribute 'notmuch-search-unread-face nil
                          :foreground notmuch/notmuch-search-unread-face-color
                          :bold nil)

      ;; notmuch buffers are useful
      (push "\\*notmuch.*\\*" spacemacs-useful-buffers-regexp)
      )
    )
  )

(defun notmuch/init-notmuch-address-history ()
  (use-package notmuch-address-history
    :config (progn

              ;; auto-complete e-mail addresses
              (setq notmuch-address-command notmuch/address-lookup-bin)
              (notmuch-address-message-insinuate)

              ;; don't auto select the first address
              (setq notmuch-address-selection-function
                    (lambda (prompt collection initial-input)
                      (completing-read prompt (cons initial-input collection) nil t nil 'notmuch-address-history)))
              )))

(defun notmuch/init-gnus-alias ()
  (use-package gnus-alias
    :init (add-hook 'message-setup-hook 'gnus-alias-determine-identity)
    :config (progn
              (if (not (boundp 'notmuch/gnus-alias-identities))
                  (setq notmuch/gnus-alias-identities notmuch/gnus-alias-identities-default))

              (if notmuch/gnus-alias-identities
                  (progn
                    ;; Define identities
                    (setq gnus-alias-identity-alist notmuch/gnus-alias-identities)

                    ;; Use first identity by default
                    (setq gnus-alias-default-identity (car (car notmuch/gnus-alias-identities)))

                    ;; Define rules to match identities
                    (if notmuch/gnus-alias-identity-rules
                        (setq gnus-alias-identity-rules notmuch/gnus-alias-identity-rules))))

              ;; message starts above reply
              (if (not (boundp 'notmuch/message-cite-reply-position))
                  (setq notmuch/message-cite-reply-position notmuch/message-cite-reply-position-default))

              (if notmuch/message-cite-reply-position
                  (setq message-cite-reply-position notmuch/message-cite-reply-position))
              )))

(defun notmuch/init-org ()
  (use-package org
    :config (progn
              (add-hook 'message-mode-hook 'turn-on-orgstruct)
              (add-hook 'message-mode-hook 'turn-on-orgstruct++)
              (add-hook 'message-mode-hook 'turn-on-orgtbl))))
