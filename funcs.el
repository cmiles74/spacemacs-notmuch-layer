;;; funcs.el --- notuch Layer functions File for Spacemacs
;;
;; Copyright (c) 2012-2016 Sylvain Benner & Contributors
;;
;; This file is not part of GNU Emacs.
;;
;;; License: GPLv3

(defun notmuch/message-delete ()
  (interactive)
  (notmuch-search-tag '("+deleted" "-inbox" "-unread"))
  (notmuch-search-next-thread))

(defun notmuch/message-receipt-archive ()
  (interactive)
  (notmuch-search-tag '("+archived" "+receipt" "-unread" "-inbox"))
  (notmuch-search-next-thread))

(defun notmuch/message-archive ()
  (interactive)
  (notmuch-search-tag '("+archived" "-inbox" "-unread"))
  (notmuch-search-next-thread))

(defun notmuch/select-identity ()
  (interactive)
  (gnus-alias-select-identity))

