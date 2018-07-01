# Notmuch Layer for Spacemacs

Notmuch is a fast, tag-based indexer for your email. It provides fast and easy
access to your email as well as a mail-reading interface for Emacs. This layer
integrates Notmuch with the rest of Spacemacs

## Setup Notmuch

Setting up Notmuch is a little out-of-scope for this document. The process is
pretty straightforward, more information can be found on the Notmuch website.

  https://notmuchmail.org
  
Personally, I use [mbsync (from the isync
project)](http://isync.sourceforge.net) to maintain a local copy of my mail in
Maildir format. After mbsync finishes downloading my mail, I run notmuch to add
it to the index. The [Arch Linux
wiki](https://wiki.archlinux.org/index.php/Isync) has a pretty good article on
getting this setup.

## Installing the Layer

To install the layer, checkout this project into your "private" layers folder in
`~/.emacs.d/private` as `notmuch`.

    git clone https://github.com/cmiles74/spacemacs-notmuch-layer.git ~/.emacs.d/private/notmuch

Next, open up your `~/.spacemacs` file and add `notmuch` to your
`dotspacemacs-configuration-layers`. You may have to rename the directory from
`spacemacs-notmuch-layer` to `notmuch`.

## Configuring the Layers

If you installed a tool to lookup addresses from notmuch
(like [this one](https://github.com/aperezdc/notmuch-addrlookup-c)), you can
tell the layer where to find the binary.

    (setq notmuch/address-lookup-bin "/usr/bin/notmuch-addrlookup"")
    
By default, the layer will set the notmuch list of messages to use colors that
match the dark Spacemacs theme (normally they are blue). If you use another
theme, you may customize these colors.

    (setq notmuch/notmuch-tag-face-color "#3f7f5f")
    (setq notmuch/notmuch-search-unread-face-color "#4f97d7")
    
By
default,
[message citation](https://www.gnu.org/software/emacs/manual/html_node/message/Insertion-Variables.html) will
default to top-posting. You can customize this as well.

    (setq notmuch/message-cite-reply-position 'above)
    
Lastly, you need to setup your identities
with [Gnus Alias](https://notmuchmail.org/emacstips/#index16h2). You can add as
many as you like to this list, they will be used when writing messages. The
first identity in the list will be used as your default identity.

    (setq notmuch/gnus-alias-identities
          '(
            ("home" nil
             "Somebody Someone <somebody@someone.com>" ;; Sender address
             nil                                       ;; Organization header
             nil                                       ;; Extra headers
             nil                                       ;; Extra body text
             "~/.signature")))

Along with your identity, you can setup some rules to help identify which
identities should be used with which email messages.

     (setq gnus-alias-identity-rules)
          '(("work" ("any" "john.doe@\\(example\\.com\\|help\\.example.com\\)" 
                      both) "work"))

The rule above will use the `work` identity when replying to messages addressed
to `john.doe@example.com` or `help.example.com`.

# Using the Layer

To start the notmuch interface...


| Key Binding | Description     |
|-------------|-----------------|
| `SPC a n`   | Notmuch Hello   |

When you area viewing a list of messages...

| Key Binding | Description                              |
|-------------|------------------------------------------|
| `d`         | Delete message at point                  |
| `a`         | Archive message at point                 |
| `C-c r`     | Tag receipt and archive message at point |

When reading messages...

| Key Binding | Description                              |
|-------------|------------------------------------------|
| `C-c i`     | Select identity                          |

# Miscellaneous

## SPACE Key Bound to Scroll Page Down Action

The notmuch modes (`notmuch-search`, `notmuch-show`, etc.) bind the scroll page
down action to the space key by default. This could cause problems if you've
bound the space key globally to something else. If you'd like to free up the
space key, rebind the page-down action.

    (progn 
      (require 'notmuch) 
      (define-key notmuch-search-mode-map " " spacemacs-cmds)
      (define-key notmuch-show-mode-map " " spacemacs-cmds))
    
A thank you goes goes out to [jernejkase](https://github.com/jernejkase) for
pointing this out.

## Custom Actions

Inevitable you'll want to add your own keybindings to tag messages the way you
would like them to be tagged. I recommend adding code to your
`dotspacemacs/user-init` function in your `~/.spacemacs` file. Here's a handy
example:

    (defun notmuch/message-crazytalk ()
      (interactive)
      (notmuch-search-tag '("+wackadoodle" "-inbox" "-unread"))
      (notmuch-search-next-thread))

    (add-hook 'notmuch-search-mode-hook
              (lambda()
                (local-set-key (kbd "c") 'notmuch/message-crazytalk)
                (which-key-add-key-based-replacements
                  "c" "Tag message as crazy talk")))

The code above will tag a message as "wackadoodle" when you have it highlighted
in your inbox and press the `c` key.
