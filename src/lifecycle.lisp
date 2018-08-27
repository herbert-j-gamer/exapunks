(in-package :exapunks)
(export
 '(repl
   halt
   kill))

(defun repl (label)
  "Create a copy of this EXA and jump to the specified label in the copy."
  (check-type label string)
  (send "REPL" (string-upcase label)))

(defun halt ()
  (send "HALT"))

(defun kill ()
  (send "KILL"))
