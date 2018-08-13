(defpackage exapunks
  (:use :cl)
  (:export
   ;; Helpers
   #:to-cliboard-with-max-lines
   #:clipboard-convert
   #:do-while
   #:do-until
   #:while
   #:while-short
   #:until
   #:forever
   #:countdown-t-to-0
   ;; File helpers
   #:find-from-file
   #:find-in-file
   ;; Manipulating Values
   #:copy
   #:move
   #:addi
   #:subi
   #:muli
   #:modi
   #:divi
   #:swiz
   ;; Branching
   #:mark
   #:jump
   #:tjmp
   #:fjmp
   ;; Testing
   #:test
   ;; Lifecycle
   #:repl
   #:halt
   #:kill
   ;; Movement
   #:link
   #:host
   ;; Communication
   #:mode
   #:void
   #:void-m
   #:test-mrd
   ;; File Manipulation
   #:make
   #:grab
   #:file
   #:seek
   #:seek-to-pos
   #:void-f
   #:drop
   #:wipe
   #:test-eof
   ;; Macros
   #:@rep
   #:rep
   #:end
   #:@
   ;; Miscellaneous
   #:note
   #:noop
   #:rand))
(in-package :exapunks)

(declaim (optimize (debug 3) (safety 3)))

;; Registers

(defun hardware-keyword (keyword)
  (= 4 (length (symbol-name keyword))))

(defun exa-integer (num)
  (<= -9999 num 9999))

(defun swizle-integer (num)
  (<= -4444 num 4444))

(defstruct numeric-expansion start stepping)

(deftype register ()
  '(or (member :x :f :file :t :m)
    (and keyword (satisfies hardware-keyword))))

(deftype register-f-or-m ()
  '(member :f :file :m))

(deftype register-number ()
  '(or (and integer (satisfies exa-integer))
    numeric-expansion))

(deftype enumber ()
  '(and integer (satisfies exa-integer)))

(deftype register-or-number ()
  '(or register register-number))

(deftype register-or-swizle-number ()
  '(or register (satisfies swizle-integer)))

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

;; Manipulating Values

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

;; Branching

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

;; Testing

(deftype test-keyword ()
  '(member :> :< :=))

(defun test (a f b)
  (check-type a register-or-number)
  (check-type b register-or-number)
  (check-type f test-keyword)
  (send "TEST" a f b))

;; Lifecycle

(defun repl (label)
  "Create a copy of this EXA and jump to the specified label in the copy."
  (check-type label string)
  (send "REPL" (string-upcase label)))

(defun halt ()
  (send "HALT"))

(defun kill ()
  (send "KILL"))

;; Movement

(defun link (target)
  (check-type target register-or-number)
  (send "LINK" target))

(defun host (register)
  (check-type register register)
  (send "HOST" register))

;; Communication

(defun mode ()
  (send "MODE"))

(defun void (register)
  (check-type register register-f-or-m)
  (send "VOID" register))

(defun void-m ()
  (send "VOID" :m))

(defun test-mrd ()
  (send "TEST" "MRD"))

;; File Manipulation

(defun make ()
  "Create and grab a new file."
  (send "MAKE"))

(defun grab (target)
  (check-type target register-or-number)
  (send "GRAB" target))

(defun file (register)
  (check-type register register)
  (send "FILE" register))

(defun seek (value)
  (check-type value register-or-number)
  (send "SEEK" value))

(defun seek-to-pos (pos)
  "Seek to certain position"
  (seek -9999)
  (when (< 0 pos)
    (seek pos)))

(defun void-f ()
  (send "VOID" :f))

(defun drop ()
  (send "DROP"))

(defun wipe ()
  (send "WIPE"))

(defun test-eof ()
  (send "TEST" "EOF"))

;; Miscellaneous

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

;; Macros

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

;; Helpers

(defmacro until (test &body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,initial-label (format nil "INIT_~A" (+ 1000 (random 1000))))
           (,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "UNTIL")
       ,test
       (tjmp ,initial-label)
       (mark ,repeat-label t)
       ,@body
       ,test
       (fjmp ,repeat-label)
       (mark ,initial-label t)
       (note "END UNTIL" t))))

(defmacro do-while (test &body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,initial-label (format nil "INIT_~A" (+ 1000 (random 1000))))
           (,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "DO WHILE")
       (mark ,repeat-label t)
       ,@body
       ,test
       (tjmp ,repeat-label)
       (note "END DO WHILE" t))))

(defmacro do-until (test &body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,initial-label (format nil "INIT_~A" (+ 1000 (random 1000))))
           (,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "DO UNTIL")
       (mark ,repeat-label t)
       ,@body
       ,test
       (fjmp ,repeat-label)
       (note "END DO UNTIL" t))))

(defmacro while (test &body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,initial-label (format nil "INIT_~A" (+ 1000 (random 1000))))
           (,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "WHILE")
       ,test
       (fjmp ,initial-label)
       (mark ,repeat-label t)
       ,@body
       ,test
       (tjmp ,repeat-label)
       (mark ,initial-label t)
       (note "END WHILE" t))))

(defmacro while-short (test &body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,initial-label (format nil "INIT_~A" (+ 1000 (random 1000))))
           (,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "WHILE (SHORT)")
       (mark ,repeat-label)
       ,test
       (fjmp ,initial-label)
       ,@body
       (jump ,repeat-label)
       (mark ,initial-label t)
       (note "END WHILE (SHORT)" t))))

(defmacro forever (&body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "FOREVER")
       (mark ,repeat-label)
       ,@body
       (jump ,repeat-label)
       (note "END FOREVER" t))))

(defmacro countdown-t-to-0 ((num) &body body)
  "Countdown to 0 using t.  Unable to do tests in loop, but x is free.
Use existing value in t when num is nil."
  (note "Countdown t")
  (when num
    (copy num :t))
  (alexandria:with-gensyms (repeat-label)
    (let ((repeat-label (format nil "COUNTDOWN_T_~A" (+ 1000 (random 1000)))))
      `(progn
         (mark ,repeat-label)
         ,@body
         (subi :t 1 :t)
         (tjmp ,repeat-label)))))

(defun count-lines (text)
  (let ((lines (str:lines text))
        (count 0))
    (dolist (line lines)
      (setf line (str:trim line))
      (when (< 0 (length line))
        (let* ((words (str:words line))
               (first (car words)))
          (cond ((string= first "NOTE")
                 nil)
                (t
                 (incf count))))))
    count))

(defmacro to-cliboard-with-max-lines ((max-lines) &body body)
  "doc"
  (let* ((mx-lines (gensym)))
    `(let ((,mx-lines ,max-lines)
           (*standard-output* (make-string-output-stream)))
       ,@body
       (let* ((text (get-output-stream-string *standard-output*))
              (line-count (count-lines text)))
         (assert (<= line-count ,mx-lines) (line-count) "Too many lines: ~A" line-count)
         (trivial-clipboard:text text)
         line-count))))

(defun clipboard-convert ()
  "doc"
  (let* ((to-convert (trivial-clipboard:text))
         (lines (str:lines to-convert))
         (output-lines '()))
    (dolist (line lines)
      (setf line (str:trim line))
      (cond
        ((string-equal line "TEST EOF")
         (push "(test-eof)" output-lines))
        ((string= line "")
         (push "" output-lines))
        (t
         (let ((words (str:words line))
               (out-words '())
               (opener "(")
               (closer ")"))
           (when words
             (let ((word (car words)))
               (cond ((string= word "@REP")
                      (push "@rep" out-words)
                      (setf closer ""))
                     ((string= word "@END")
                      (setf opener ""))
                     (t
                      (push (string-downcase word) out-words))))
             (dolist (word (cdr words))
               (cond
                 ((string= word "F")
                  (push ":file" out-words))
                 ((member word '("X" "T" "F" "M" "<" ">" "=") :test #'string-equal)
                  (push (string-downcase (format nil ":~A" word))
                        out-words))
                 ((ppcre:scan "^(-?[1-9][0-9]*|0)$" word)
                  (push word out-words))
                 ((ppcre:scan "^@\\{[0-9]+,[0-9]+\\}$" word)
                  (let (start stepping)
                    (ppcre:register-groups-bind (start stepping)
                        ("^@\\{([0-9]+),([0-9]+)\\}$" word)
                      (push (format nil "(@ ~A ~A)" start stepping) out-words))))
                 ((ppcre:scan "^#[0-9A-Z]{4}$" word)
                  (push (format nil
                                ":~A"
                                (string-downcase (str:substring 1 5 word)))
                        out-words))
                 (t
                  (push (string-downcase (format nil "\"~A\"" word))
                        out-words))))
             (push (format nil "~A~{~A~^ ~}~A"
                           opener
                           (nreverse out-words)
                           closer)
                   output-lines))))))
    (trivial-clipboard:text (str:unlines (nreverse output-lines)))))

;; File helpers

(defun find-from-file (search-key save-to row-offset data-offset)
  (check-type search-key register-or-number)
  (check-type save-to register)
  (let ((read-loop-id (format nil "READ_~A" (+ 1000 (random 1000))))
        (test-loop-id (format nil "TEST_~A" (+ 1000 (random 1000)))))

    (note "find-from-file")
    (mark test-loop-id)
    (test :file := search-key)
    (tjmp read-loop-id)
    (when (1- row-offset)
      (seek (1- row-offset)))
    (jump test-loop-id)

    (note "Extract")
    (mark read-loop-id)
    (when (1- data-offset)
      (seek (1- data-offset)))
    (copy :file save-to)))

(defun find-in-file (search-key &optional (row-offset 0))
  (check-type search-key register-or-number)
  (check-type row-offset register-or-number)
  (note "find-in-file")
  (until (test :file := search-key)
    (when (< 0 row-offset)
      (seek (1- row-offset)))))

