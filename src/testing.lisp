(in-package :exapunks)
(export
 '(test))

(deftype test-keyword ()
  '(member :> :< :=))

(defun test (a f b)
  (check-type a register-or-number)
  (check-type b register-or-number)
  (check-type f test-keyword)
  (send "TEST" a f b))
