#|
This file is a part of exapunks project.
Copyright (c) 2018 herbert.j.gamer (herbert.j.gamer@gmail.com)
|#

#|
Authorherbert.j.gamer:  (herbert.j.gamer@gmail.com)
|#

(defsystem "exapunks"
  :version "0.1.0"
  :author "herbert.j.gamer"
  :license "MIT"
  :depends-on ("let-plus"
               "cl-ppcre"
               "alexandria"
               "cl-algebraic-data-type"
               "trivial-clipboard"
               "str")
  :components ((:module "src"
                :components
                ((:file "package")
                 (:file "types")
                 (:file "exapunks")
                 (:file "branching")
                 (:file "communication")
                 (:file "file")
                 (:file "lifecycle")
                 (:file "macros")
                 (:file "movement")
                 (:file "testing")
                 (:file "value-manipulation")
                 (:file "misc")
                 (:file "loops")
                 (:file "clipboard"))))
  :description ""
  :long-description
  #.(read-file-string
     (subpathname *load-pathname* "README.org"))
  :in-order-to ((test-op (test-op "exapunks-test"))))
