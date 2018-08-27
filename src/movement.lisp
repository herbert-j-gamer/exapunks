(in-package :exapunks)
(export
 '(link
   host))

(defun link (target)
  (check-type target register-or-number)
  (send "LINK" target))

(defun host (register)
  (check-type register register)
  (send "HOST" register))

