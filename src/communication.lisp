(in-package :exapunks)
(export
 '(mode
   void
   void-m
   test-mrd))

(defun mode ()
  (send "MODE"))

(defun void (register)
  (check-type register register-f-or-m)
  (send "VOID" register))

(defun void-m ()
  (send "VOID" :m))

(defun test-mrd ()
  (send "TEST" "MRD"))
