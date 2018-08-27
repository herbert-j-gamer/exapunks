(in-package :exapunks)
(export
 '(countdown-t-to-0
   do-until
   do-while
   forever
   until
   while
   while-short))

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

(defmacro forever (&body body)
  (alexandria:with-gensyms (initial-label repeat-label)
    `(let ((,repeat-label (format nil "REPEAT_~A" (+ 1000 (random 1000)))))
       (note "FOREVER")
       (mark ,repeat-label)
       ,@body
       (jump ,repeat-label)
       (note "END FOREVER" t))))

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
