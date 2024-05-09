(import aoc-lib 
        (srfi 152))

(define inp (read-all (open-input-file "06/input.txt")))
(define rows (lines inp))
(define tme (colon (car rows)))
(define distance (colon (cadr rows)))

(define time1 (sp-split-n tme))
(define time2 
  (list (string->number (apply string-append (sp-split tme)))))
(define distance1 (sp-split-n distance))
(define distance2 
  (list (string->number (apply string-append (sp-split distance)))))

(define (quadratic a b c)
  (let ((det (sqrt (- (* b b) (* 4 a c))))
        (calc (lambda (d) (/ (+ (- b) d) (* 2 a)))))
    (cons (calc det)
          (calc (- det)))))

(define (solve t d)
  (let ((sols (quadratic -1 t (- d))))
    (inexact->exact (- (ceiling (cdr sols)) (ceiling (car sols))))))

(day-answers 
  6 
  (foldl * 1 (map solve time1 distance1))
  (foldl * 1 (map solve time2 distance2)))
