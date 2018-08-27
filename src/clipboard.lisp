(in-package :exapunks)
(export
 '(to-cliboard-with-max-lines
   clipboard-convert))

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
