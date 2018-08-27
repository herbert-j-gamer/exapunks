(in-package :exapunks)

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

