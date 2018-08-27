(in-package :exapunks)
(export
 '(mark
   jump
   tjmp
   fjmp))

(defun mark (label &optional suppress-newline)
  (check-type label string)
  (unless suppress-newline
    (terpri))
  (send "MARK" (string-upcase label)))

(defun jump (label)
  (check-type label string)
  (send "JUMP" (string-upcase label)))

(defun tjmp (label)
  (check-type label string)
  (send "TJMP" (string-upcase label)))

(defun fjmp (label)
  (check-type label string)
  (send "FJMP" (string-upcase label)))

