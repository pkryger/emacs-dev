;;; configure-git.el --- Configure git username, emacsl and autosetupmerge  -*- lexical-binding: t; -*-


;;; Commentary:
;;
;; Set user name, user email and branch automerge in git.  This enables calling
;; git commit.

(require 'vc-git)
;;; Code:

(dolist (setting '(("user.email" "emacs-dev[bot]@users.noreply.github.com")
                   ("user.name" "emacs-dev[bot]")
                   ("branch.autosetupmerge" "true")))
  (apply #'vc-git-command
         (append (list nil 0 nil "config" "--global")
                 setting)))

(provide 'configure-git)

;;; configure-git.el ends here
