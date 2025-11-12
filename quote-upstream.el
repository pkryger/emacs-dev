;;; quote-upstream.el --- Workaround for @{upstream} not working on Windows -*- lexical-binding: t; -*-


;;; Commentary:
;;
;; This is a workaround for issue that @{upstream} doesn't work on Windows when
;; running under MSYS2 on GitHub runner.  It seems that braces (but braces
;; only!) need to be quoted.

;;; Code:

(defun pk/quote-upstream (orig-fun &rest args)
  ;; checkdoc-params: (orig-fun)
  "Substitute @{upstream} with @\\{upstream\\} in ARGS."
  (apply orig-fun
	     (mapcar (lambda (arg)
		           (if (and (stringp arg)
			                (string= "@{upstream}" arg))
		               "@\\{upstream\\}"
		             arg))
		         args)))

(advice-add #'call-process
	    :around #'pk/quote-upstream)

(provide 'quote-upstream)

;;; quote-upstream.el ends here
