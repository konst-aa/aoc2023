(import aoc-lib
        vector-lib ; clam 9
        (srfi 1)   ; lists
        (srfi 113) ; sets
        (srfi 128) ; comparators
        (srfi 152) ; string-lib
        )

(define inp (read-all (open-input-file (string-append "00/sample.txt"))))
; (define inp (read-all (open-input-file (string-append "00/input.txt"))))
(define rows (lines inp))

(day-answers 
  0
  0
  0)
