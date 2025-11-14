;;; perl-makeinfo.el --- Workaround for @{upstream} not working on Windows -*- lexical-binding: t; -*-

;;; Commentary:
;;
;; This is a workaround for issue that makeinfo doesn't work on Windows when
;; running under MSYS2 on GitHub runner.  It seems that `make-process' is not
;; able to map shebang (/usr/bin/perl) to a perl

;;; Code:

(defun pk/perl-makeinfo (orig-fun &rest args)
  ;; checkdoc-params: (orig-fun)
  "Use perl interpreter to call makeinfo with ARGS."
  (if (equal "makeinfo" (car args))
      (let ((args (cdr args)))
        (apply orig-fun
               (cons "perl"
                     (append (take 3 args)
                             (cons (expand-file-name "makeinfo"
                                                     (file-name-directory
                                                      (executable-find "install-info")))
                                   (nthcdr 3 args))))))
    (apply orig-fun args)))

(advice-add #'call-process
	    :around #'pk/perl-makeinfo)

(provide 'perl-makeinfo)

;;; perl-makeinfo.el ends here
