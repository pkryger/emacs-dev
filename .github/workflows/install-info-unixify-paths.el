;;; install-info-unixify-paths.el --- Advice for call-process to unixify install info paths  -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; When calling from a pwsh all paths are Windows style.  However, MSYS2
;; install-info requires UNIX style paths on Windows.
;;
;; N.B. I couldn't make  MSYS2/MinGW64 one to work when called from pwsh.

;;; Code:

(defun install-info-unixify-paths (args)
  "Unixyfy paths when car ARGS is install-info."
  (if (equal (car-safe args) "install-info")
      (append (take 4 args)
              (mapcar (lambda (arg)
                        (if (string-match (rx bos
                                              (group alpha)
                                              ":"
                                              (group "/" (one-or-more any)))
                                          arg)
                            (concat "/"
                                    (downcase (match-string 1 arg))
                                    (match-string 2 arg))
                          arg))
                      (nthcdr 4 args)))
    args))

(advice-add #'call-process
            :filter-args
            #'install-info-unixify-paths)

(provide 'install-info-unixify-paths)

;;; install-info-unixify-paths.el ends here
