(in-package :exapunks)
(export
 '(note
   noop
   rand))

(defun note (&optional (comment "") suppress-newline)
  (cond ((= 0 (length comment))
         (format t "~%"))
        (t
         (unless suppress-newline
           (terpri))
         (send "NOTE" comment))))

(defun noop ()
  (send "NOOP"))

(defun rand (low high reg)
  (check-type low register-or-number)
  (check-type high register-or-number)
  (check-type reg register)
  (send "RAND" low high reg))

