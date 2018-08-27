(in-package :exapunks)

(defun send (&rest values)
  (let ((as-strings '()))
    (dolist (val values)
      (cond ((eq val :file)
             (push "F" as-strings))
            ((and (symbolp val)
                  (= 4 (length (symbol-name val))))
             (push (format nil "#~A" val) as-strings))
            ((numeric-expansion-p val)
             (push (format nil "@{~A,~A}"
                           (numeric-expansion-start val)
                           (numeric-expansion-stepping val))
                   as-strings))
            (t
             (push (format nil "~A" val) as-strings))))
    (princ (str:unwords (nreverse as-strings)))
    (terpri)))
