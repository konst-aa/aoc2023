(import aoc-lib
        vector-lib
        (chicken string)
        (srfi 1)
        (srfi 113)
        (srfi 128))

(define inp (read-all (open-input-file "04/input.txt")))
(define rows (lines inp))

(define (row->card row)
  (let* ((relevant (colon row))
         (t (string-split relevant "|"))
         (winning-numbers (sp-split-n (car t)))
         (our-numbers (sp-split-n (cadr t))))
    (cons winning-numbers our-numbers)))

(define cards (map row->card rows))

(define comp (make-default-comparator))

(define (wins card)
  (let* ((winning-set (list->set comp (car card)))
         (our-set (list->set comp (cdr card)))
         (intr (set-intersection winning-set our-set)))
    (length (set->list intr))))

(define wins-vec (apply vector (map wins cards)))
(define points-vec 
  (vector-map 
    (lambda (i item)
      (if (zero? item)
        0
        (expt 2 (- item 1))))
    wins-vec))

(define upper-bounds (vector-length points-vec))

(define dp (vector-map (lambda (i _) 1) wins-vec))

(define (dp-fn i _ item)
  (let* ((curr (vector-ref wins-vec i))
         (our-bounds (min (+ i curr 1) (vector-length points-vec)))
         (winning-range (range (+ i 1) our-bounds 1)))
    (set! (vector-ref dp i) 
      (sum (cons item (map (lambda (i) (vector-ref dp i)) winning-range))))))

(vector-fold-right dp-fn 0 dp)

(define sol1 (vector-apply + points-vec))
(define sol2 (vector-apply + dp))

(day-answers 4 sol1 sol2)
