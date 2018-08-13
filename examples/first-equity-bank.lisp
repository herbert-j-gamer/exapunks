(defpackage exapunks.first-equity-bank
  (:use :cl :exapunks))
(in-package :exapunks.first-equity-bank)

(defun solution-1155 ()
  (to-cliboard-with-max-lines (50)
    (let ((main-loop-times 23))
      ;; INIT
      (link 800)
      (link 800)
      (link 800)

      (note "800-806" "here")
      (copy 800 :X)
      (while (test :x :< 806)
        (repl "start")
        (addi :x 1 :x))

      (mark "start")
      (link :x)
      (while (test :cash :> main-loop-times)
        (dotimes (i main-loop-times)
          (copy 20 :disp)))
      (while (test :cash :> 0)
        (copy 20 :disp)))))

(defun solution-1149 ()
  (to-cliboard-with-max-lines (50)
    (let ((main-loop-times 23))
      ;; INIT
      (link 800)
      (link 800)
      (link 800)

      (note "800-806" "here")
      (copy 800 :X)
      (while-short (test :x :< 806)
        (repl "start")
        (addi :x 1 :x))

      (mark "start")
      (link :x)
      (while (test :cash :> main-loop-times)
        (dotimes (i main-loop-times)
          (copy 20 :disp)))
      (while (test :cash :> 0)
        (copy 20 :disp)))))

(defun solution-1129 ()
  (to-cliboard-with-max-lines (50)
    (let ((main-loop-times 29))
      ;; INIT
      (link 800)
      (link 800)
      (link 800)

      ;; make 1-6
      (note "800-806" "here")
      (do-while (test :x :< 6)
        (repl "start")
        (addi :x 1 :x))

      (mark "start")
      (addi :x 800 :X)
      (link :x)
      (do-while (test :cash :> main-loop-times)
        (dotimes (i main-loop-times)
          (copy 20 :disp)))

      (while (test :cash :> 0)
        (copy 20 :disp)))))
