(import aoc-lib
        (chicken string)
        (chicken sort)
        (srfi 1)
        (srfi 113)
        (srfi 128))

(define input-string (read-all (open-input-file "03/input.txt")))
(define row-strings (string-split input-string "\n"))

(define row-length (string-length (car row-strings)))
(define num-rows (length row-strings))

(define rows
  (let* ((row-charlists (map string->list row-strings))
         (row-vectors (map (lambda (row) (apply vector row)) row-charlists)))
    (apply vector row-vectors)))

(define (get-char i j)
  (nd-get rows i j))

(define (find-indices check?)
  (define (helper i j)
    (if (check? (get-char i j))
      (vector (cons i j))
      (vector)))
  (vector->list
    (vector-flatmap
      (lambda (i row)
        (vector-flatmap (lambda (j _) (helper i j)) row))
      rows)))

(define (part? char)
  (not (or (digit? char) (eq? char #\.))))

(define (gear? char)
  (eq? char #\*))

(define (greedy-number i j)
  (define (go step j acc)
    (cond
      ((or (< j 0) (>= j row-length)) acc)
      ((digit? (get-char i j))
       (go step (+ j step) (cons (cons i j) acc)))
      (else acc)))
  (if (or (< i 0) (>= i num-rows) (< j 0) (>= j row-length))
    (list)
    (let* ((behind (go -1 j (list)))
           (t (reverse (go 1 j (list))))
           (ahead (if (null? t) (list) (cdr t))))
      (append behind ahead))))

(define (nearby-numbers i j)
  (define offsets (list -1 0 1))
  (flatmap
    (lambda (off-i)
      (filter
        (compose not null?)
        (map (lambda (off-j)
               (greedy-number (+ i off-i) (+ j off-j)))
             offsets)))
    offsets))

(define (row-col-list->number row-col-list)
  (list->number (map (lambda (rc) (get-char (car rc) (cdr rc)))
                     row-col-list)))
(define (prune lst)
  (set->list (list->set (make-default-comparator) lst)))

(define part-indices (find-indices part?))

(define sol1-row-cols
  (flatmap (lambda (rc)
             (nearby-numbers (car rc) (cdr rc)))
           part-indices))

(define gear-indices (find-indices gear?))

(define sol2
  (sum (map (lambda (rc)
              (let ((neighbors (prune (nearby-numbers (car rc) (cdr rc)))))
                (if (= (length neighbors) 2)
                  (apply * (map row-col-list->number neighbors))
                  0)))
            gear-indices)))

(day-answers 3
             (sum (map row-col-list->number (prune sol1-row-cols)))
             sol2)
