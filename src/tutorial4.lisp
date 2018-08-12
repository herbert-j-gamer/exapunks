(defpackage exapunks.tutorial4
  (:use :cl :exapunks))
(in-package :exapunks.tutorial4)

(defun solution-137 ()
  (to-cliboard-with-max-lines (50)
    (labels ((make-loop (name exit-name size)
               (mark name)
               (test :x :< size)
               (tjmp exit-name)
               (copy :x :f)
               (loop for i from 1 below size
                  do (subi :x i :f))
               (subi :x size :x)
               (jump name)))
      ;; Init
      (link 800)
      (grab 200)
      (copy :f :X)
      (wipe)
      (link 800)
      (make)

      ;; Loop
      (let* ((upper 23) ;; 24:151 23:140 22:149
             (loop-size 3)
             (void-size (- 30 (+ upper loop-size))))

        (assert (< 0 void-size) (void-size) ">= 0 ~A" void-size)
        (make-loop "loop_a" "loop" upper)

        ;; Loop
        (mark "loop")
        (loop for i from 0 to loop-size
           do (subi :x i :f))
        (subi :x (1+ loop-size) :x)
        (test :x :< 0)
        (fjmp "loop")
        (seek :x)
        (seek 1)

        (if (< loop-size void-size) 
            (progn
              (note "end")
              (loop for i from 1 to (1+ loop-size)
                 do (void :f)))
            (progn
              (mark "end")
              (loop for i from 1 to void-size
                 do (void :f))
              (jump "end")))))))

(defun solution-140 ()
  (to-cliboard-with-max-lines (50)
    (labels ((make-loop (name exit-name size)
               (mark name)
               (test :x :< size)
               (tjmp exit-name)
               (copy :x :f)
               (loop for i from 1 below size
                  do (subi :x i :f))
               (subi :x size :x)
               (jump name)))
      ;; Init
      (link 800)
      (grab 200)
      (copy :f :X)
      (wipe)
      (link 800)
      (make)

      ;; Loop
      (let* ((max-total 29)
             (upper 23) ;; 24:151 23:140 22:149
             (lower (- max-total upper 1)))
        (assert (< lower upper)
                (lower upper)
                ">= ~A ~A" lower upper)
        (make-loop "loop_a" "loop_b" upper)
        (make-loop "loop_b" "final" lower))

      (mark "final")
      (copy :x :f)
      (subi :x 1 :x)
      (test :x :< 0)
      (fjmp "final"))))

(defun triple-loop ()
  (to-cliboard-with-max-lines (50)
    (labels ((make-loop (name exit-name size)
               (mark name)
               (test :x :< size)
               (tjmp exit-name)
               (copy :x :f)
               (loop for i from 1 below size
                  do (subi :x i :f))
               (subi :x size :x)
               (jump name)))
      ;; Init
      (link 800)
      (grab 200)
      (copy :f :X)
      (wipe)
      (link 800)
      (make)

      ;; Loop
      (let* ((max-total 22)
             (upper 16) ;; 24:151 23:140 22:149
             (bottom 2)
             (lower (- max-total (+ upper bottom))))
        (assert (< bottom lower upper)
                (bottom lower upper)
                ">= ~A ~A ~A" bottom lower upper)
        (make-loop "loop_a" "loop_b" upper)
        (make-loop "loop_b" "loop_c" lower)
        (make-loop "loop_c" "final" lower))

      (mark "final")
      (copy :x :f)
      (subi :x 1 :x)
      (test :x :< 0)
      (fjmp "final"))))

(defun inner-unrolled ()
  (to-cliboard-with-max-lines (50)
    (let ((a 18)
          (b 10)
          (c 4))
      (labels ((cntd-loop (name start end)
                 (mark name)
                 (loop for i from 0 below (- start end)
                    do (subi :x i :f))
                 (subi :x (- start end) :x)))
        ;; Get countdown number from file
        (link 800)
        (grab 200)
        (copy :f :X)  ;; Stored in x
        (wipe)
        (link 800)
        (make)

        (modi :x 2 :t)
        (tjmp "test")
        (copy :x :f)
        (subi :x 1 :x)
        (mark "test")  ;; Countdown start

        (test :x :> a)
        (tjmp "a")

        (test :x :> b)
        (tjmp "b")

        (test :x :> c)
        (tjmp "c")

        (jump "final")

        ;; Countdown
        (cntd-loop "a" a b)
        (cntd-loop "b" b c)
        (cntd-loop "c" c 0)

        ;; Again, or finish?
        (test :x :> c)
        (tjmp "test")

        (mark "final")
        (copy :x :f)
        (subi :x 1 :f)
        (subi :x 2 :x)
        (test :x :< 0)
        (fjmp "final")))))

(defun partial-pos ()
  (to-cliboard-with-max-lines (50)
    (labels ((partial-loop (exit-name start next-start)
               (let ((len (- start next-start)))
                 (test :X :< start)
                 (tjmp exit-name)
                 (subi :X len :X)
                 (loop for i from len downto 1
                    do (addi :X i :F)))))
      (let ((loop-length 28) ;; 31 or less
            (partial-pos 11)) ;; Good points: 11
        (link 800)
        (grab 200)
        (copy :F :X)
        (wipe)
        (link 800)
        (make)

        (partial-loop "LOOP_B" loop-length partial-pos)
        (mark "INNER_A")
        (subi :X partial-pos :X)
        (loop for i from partial-pos downto 1
           do (addi :X i :F))

        (mark "LOOP_B")
        (test :X :< partial-pos)
        (fjmp "INNER_A")

        (mark "FINAL")
        (copy :X :F)
        (subi :X 1 :X)
        (test :X :< 0)
        (fjmp "FINAL")))))

(defun backtracker ()
  (to-cliboard-with-max-lines (50)
    (let ((loop-size 19)) ;; 24 19 9
      ;; Init
      (link 800)
      (grab 200)
      (copy :f :X)
      (wipe)
      (link 800)
      (make)

      ;; Loop
      (mark "loop")
      (loop for i from 0 to loop-size
         do (subi :x i :f))
      (subi :x (1+ loop-size) :x)
      (test :x :< 0)
      (fjmp "loop")
      (seek :x)
      (seek 1)
      (mark "end")
      (loop for i from 1 to (- 35 loop-size)
         do (void :f))
      (jump "end")
      )))

