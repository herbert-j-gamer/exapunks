(defpackage exapunks.workforce
  (:use :cl :exapunks))
(in-package :exapunks.workforce)

(defun basic-654 ()
  (to-cliboard-with-max-lines (100)
    (labels ((get-file ()
               "Moves to correct file and opens it."
               ;; Read user name
               (grab 300)
               (copy :F :X)
               (wipe)

               ;; Find file id matching username
               (link 800)
               (grab 199)
               ;; Find if
               (mark "LOOPFILEID")
               (test :F := :X)
               (tjmp "READFILEID")
               (seek 2)
               (jump "LOOPFILEID")
               ;; Found row
               (mark "READFILEID")
               (seek 1)
               ;; Place in :x
               (copy :F :X)
               (drop)
               (link 799)
               (grab :X))
             )
      (get-file)

      (seek 2)
      (copy 0 :X)

      (mark "LOOPPROCESS")
      (test :F :> 75)
      (fjmp "EOFTEST")
      (seek -1)
      (addi :X :F :X)
      (subi :X 75 :X)
      (seek -1)
      (copy 75 :F)
      (mark "EOFTEST")
      (test-eof)
      (fjmp "LOOPPROCESS")


      (repl "APPEND")
      (divi :X 75 :X)

      (test :X :> 0)
      (mark "LOOPWRITE")
      (fjmp "END")
      (copy 75 :F)
      (subi :X 1 :X)
      (test :X :> 0)
      (tjmp "LOOPWRITE")
      (jump "DIE")

      (mark "END")
      (test :X :> 0)
      (fjmp "DIE")
      (copy :X :F)
      (mark "DIE")
      (file :M)
      (halt)

      (mark "APPEND")
      (modi :X 75 :X)
      (test :X :> 0)
      (fjmp "DIE2")
      (copy :M :T)
      (noop)
      (grab :T)
      (seek 9999)
      (copy :X :F)
      (halt)

      (mark "DIE2")
      (void :M))))

(defun fail-594 ()
  (to-cliboard-with-max-lines (100)
    (let ((username-file-id 300)
          (directory-file-id 199)
          (max-cash 75))
      (labels ((find-from-file (search-key save-to row-offset data-offset)
                 ;; (check-type search-key register-or-number)
                 ;; (check-type save-to register)
                 (let ((read-loop-id (format nil "READ_~A" (+ 1000 (random 1000))))
                       (test-loop-id (format nil "TEST_~A" (+ 1000 (random 1000)))))

                   (note "Find")
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
               (get-file ()
                 "Moves to correct file and opens it."
                 ;; Read user name
                 (grab username-file-id)
                 (copy :file :X)
                 (wipe)

                 ;; Find file id matching username
                 (link 800)
                 (grab directory-file-id)

                 (find-from-file :x :x 3 2)
                 (note "File ID now in x")

                 (drop)
                 (link 799)
                 (grab :X))
               (get-file-remaining-length-x ()
                 (let ((loop-id (format nil "keep_reading_~A" (+ 100 (random 100)))))
                   (copy 0 :x)
                   (mark loop-id)
                   (addi :x 1 :x)
                   (seek 1)
                   (test-eof)
                   (fjmp loop-id)))
               (get-file-total-x ()
                 (let ((loop-id (format nil "keep_reading_~A" (+ 100 (random 100)))))
                   (copy :file :x)
                   (mark loop-id)
                   (addi :file :X :x)
                   (test-eof)
                   (fjmp loop-id)))
               )
        (get-file)

        ;; Numbers start at 3rd value
        (seek 2)

        ;; (get-file-remaining-length-x)

        (repl "copy_values")

        (seek-to-pos 2)
        (copy :m :x) ;; Get new file id

        (mark "SEND")
        (addi :file (- 9999 max-cash) :m)
        (test-eof)
        (fjmp "SEND")
        (kill)

        (repl "count_rewritten")

        (seek-to-pos 2)
        (get-file-total-x)
        (subi :x :m :x)

        ;; Write end 75s
        (while (test :x :> max-cash)
          (copy max-cash :file)
          (subi :x max-cash :x))

        (test :x :> 0)
        (fjmp "SKIP_FINISH")
        (copy :x :file)
        (mark "SKIP_FINISH")

        (seek-to-pos 2)
        (mark "THE_END")
        (copy :m :file)
        (jump "THE_END")

        ;; (halt)

        ;; EXA 2 -------------------------

        (mark "copy_values")
        (make)
        (file :m)

        (mark "L1")
        (subi :m (- 9999 max-cash) :file)
        (jump "L1")
        ;; Dies here

        ;; ExA 3 -------------------------

        (mark "count_rewritten")
        (grab :x)
        (copy 0 :x)
        (get-file-total-x)
        (copy :x :m)

        (seek-to-pos 0)
        (mark "SEND_START")
        (copy :file :m)
        (test-eof)
        (fjmp "SEND_START")
        (kill)
        (wipe))))
  )

(defun better-380 ()
  (to-cliboard-with-max-lines (100)
    (let ((username-file-id 300)
          (directory-file-id 199)
          (max-cash 75))
      (labels ((find-from-file (search-key save-to row-offset data-offset)
                 ;; (check-type search-key register-or-number)
                 ;; (check-type save-to register)
                 (let ((read-loop-id (format nil "READ_~A" (+ 1000 (random 1000))))
                       (test-loop-id (format nil "TEST_~A" (+ 1000 (random 1000)))))

                   (note "Find")
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
               (get-file ()
                 "Moves to correct file and opens it."
                 ;; Read user name
                 (grab username-file-id)
                 (copy :file :X)
                 (wipe)

                 ;; Find file id matching username
                 (link 800)
                 (grab directory-file-id)

                 (find-from-file :x :x 3 2)
                 (note "File ID now in x")

                 (drop)
                 (link 799)
                 (grab :X))
               (get-file-remaining-length-x ()
                 (let ((loop-id (format nil "keep_reading_~A" (+ 100 (random 100)))))
                   (copy 0 :x)
                   (mark loop-id)
                   (addi :x 1 :x)
                   (seek 1)
                   (test-eof)
                   (fjmp loop-id)))
               (get-file-total-x ()
                 (let ((loop-id (format nil "keep_reading_~A" (+ 100 (random 100)))))
                   (copy :file :x)
                   (mark loop-id)
                   (addi :file :X :x)
                   (test-eof)
                   (fjmp loop-id)))
               )
        (get-file)

        ;; Numbers start at 3rd value
        (seek 2)

        ;; (get-file-remaining-length-x)

        (repl "copy_values")

        (seek-to-pos 2)
        (copy :m :x) ;; Get new file id

        (mark "SEND")
        (addi :file (- 9999 max-cash) :m)
        (test-eof)
        (fjmp "SEND")
        (kill)

        (repl "count_rewritten")

        (seek-to-pos 2)
        (get-file-total-x)
        (subi :x :m :x)

        ;; Write end 75s
        (while (test :x :> max-cash)
          (copy max-cash :file)
          (copy max-cash :file)
          (copy max-cash :file)
          (copy max-cash :file)
          (copy max-cash :file)
          (copy max-cash :file)
          (copy max-cash :file)
          (subi :x (* 7 max-cash) :x))
        ;; Cleanup
        (while (test :x :< 0)
          (seek -1)
          (void :f)
          (addi :x max-cash :x))

        (test :x :> 0)
        (fjmp "SKIP_FINISH")
        (copy :x :file)
        (mark "SKIP_FINISH")

        (seek-to-pos 2)
        (mark "THE_END")
        (copy :m :file)
        (jump "THE_END")

        ;; (halt)

        ;; EXA 2 -------------------------

        (mark "copy_values")
        (make)
        (file :m)

        (mark "L1")
        (subi :m (- 9999 max-cash) :file)
        (jump "L1")
        ;; Dies here

        ;; ExA 3 -------------------------

        (mark "count_rewritten")
        (grab :x)
        (copy 0 :x)
        (get-file-total-x)
        (copy :x :m)

        (seek-to-pos 0)
        (mark "SEND_START")
        (copy :file :m)
        (test-eof)
        (fjmp "SEND_START")
        (kill)
        (wipe)))))
