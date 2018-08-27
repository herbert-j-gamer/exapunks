(in-package :exapunks)
(export
 '(;; Core
   make
   grab
   file
   seek
   void-f
   drop
   wipe
   test-eof
   ;; Helpers
   seek-to-pos
   find-from-file
   find-in-file
   ))

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

(defun void-f ()
  (send "VOID" :f))

(defun drop ()
  (send "DROP"))

(defun wipe ()
  (send "WIPE"))

(defun test-eof ()
  (send "TEST" "EOF"))

(defun seek-to-pos (pos)
  "Seek to certain position"
  (seek -9999)
  (when (< 0 pos)
    (seek pos)))

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
