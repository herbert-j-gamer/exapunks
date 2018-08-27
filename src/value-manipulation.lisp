(in-package :exapunks)
(export
 '(copy
   move
   addi
   subi
   muli
   modi
   divi
   swiz))

(defun copy (source target)
  "Copy the value of the first operand into the second operand."
  (check-type source register-or-number)
  (check-type target register)
  (send "COPY" source target))

(defun move (source target)
  "Alias of copy."
  (copy source target))

(defun addi (source-a source-b target)
  (check-type source-a register-or-number)
  (check-type source-b register-or-number)
  (check-type target register)
  (send "ADDI" source-a source-b target))

(defun subi (source-a source-b target)
  (check-type source-a register-or-number)
  (check-type source-b register-or-number)
  (check-type target register)
  (send "SUBI" source-a source-b target))

(defun muli (source-a source-b target)
  (check-type source-a register-or-number)
  (check-type source-b register-or-number)
  (check-type target register)
  (send "MULI" source-a source-b target))

(defun modi (source-a source-b target)
  (check-type source-a register-or-number)
  (check-type source-b register-or-number)
  (check-type target register)
  (send "MODI" source-a source-b target))

(defun divi (source-a source-b target)
  (check-type source-a register-or-number)
  (check-type source-b register-or-number)
  (check-type target register)
  (send "DIVI" source-a source-b target))

(defun swiz (source-a source-b target)
  (check-type source-a register-or-number)
  (check-type source-b register-or-swizle-number)
  (check-type target register)
  (send "SWIZ" source-a source-b target))
