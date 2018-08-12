#|
This file is a part of exapunks project.
Copyright (c) 2018 herbert.j.gamer (herbert.j.gamer@gmail.com)
|#

(defsystem "exapunks-test"
  :defsystem-depends-on ("prove-asdf")
  :author "herbert.j.gamer"
  :license "MIT"
  :depends-on ("exapunks"
               "prove")
  :components ((:module "tests"
                        :components
                        ((:test-file "exapunks"))))
  :description "Test system for exapunks"

  :perform (test-op (op c) (symbol-call :prove-asdf :run-test-system c)))
