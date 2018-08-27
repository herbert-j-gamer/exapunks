(in-package :exapunks)
(export
 '(@rep
   rep
   end
   @))

(defun rep (times)
  "Start a repetition macro"
  (check-type times enumber)
  (send "@REP" times))

(defun end ()
  "Terminate a macro"
  (send "@END"))

(defmacro @rep (times &body body)
  `(progn
     (rep ,times)
     ,@body
     (end)))

(defun @ (start stepping)
  "Macro expander"
  (make-numeric-expansion :start start :stepping stepping))
