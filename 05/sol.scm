(import aoc-lib
        (srfi 1)
        (srfi 152))

(define input-string (read-all (open-input-file "05/input.txt")))

(define sections (string-split input-string "\n\n"))

(define (prune-empty str-lst)
  (filter (lambda (s) (not (equal? s ""))) str-lst))

(define seeds
  (let* ((seeds-row (car sections))
         (seeds-str (cadr (string-split seeds-row ":"))))
    (map string->number
         (prune-empty (string-split seeds-str " ")))))

(set! sections (cdr sections))

(define (build-map row)
  (let* ((range-info (map string->number (string-split row " ")))
         (range-length (caddr range-info))
         (dest-start (car range-info))
         (source-start (cadr range-info))
         (source-end (+ source-start range-length)))
    (lambda (seed-range)
      (let* ((seed-start (car seed-range))
             (seed-end (cdr seed-range))
             (internal-start (min seed-end (max seed-start source-start)))
             (internal-end (max seed-start (min seed-end source-end)))
             (mapped-start (+ dest-start (- internal-start source-start)))
             (mapped-end (+ dest-start (- internal-end source-start)))
             (mapped-range (cons mapped-start mapped-end))
             (excess-pre
               (if (< seed-start source-start)
                 (list (cons seed-start (min seed-end (- source-start 1))))
                 (list)))
             (excess-post
               (if (> seed-end source-end)
                 (list (cons (max seed-start (+ source-end 1)) seed-end))
                 (list))))
        (cons (if (and (<= seed-start source-end)
                       (>= seed-end source-start))
                (list mapped-range)
                (list))
              (append excess-pre excess-post))))))

(define (build-layer map-lst)
  ;; no need to absorb ranges, max amount of ranges is 3 ^ 7 it seems
  (define (helper seed-range)
    (define (fold-fn acc item)
      (let* ((processed (car acc))
             (unprocessed (cadr acc))
             (res (map item unprocessed)))
        (list (append (flatmap car res) processed)
              (flatmap cdr res))))
    (let ((res (foldl fold-fn (list (list) (list seed-range)) map-lst)))
      (append (car res) (cadr res))))
  (lambda (seed-ranges)
    (flatmap helper seed-ranges)))

(define (section->map-lst section) ; abstracted like this for debugging
  (let ((rows (cdr (prune-empty (string-split section "\n")))))
    (map build-map rows)))

(define section->layer
  (compose build-layer section->map-lst))

(define layers (map section->layer sections))
(define composed-layers (apply compose (reverse layers)))

(define t1
  (map (lambda (s) (cons s s)) seeds))

(define t2
  (map (lambda (lst) (cons (car lst) (+ (car lst) (cadr lst))))
       (apply group-two seeds)))

(print (length (composed-layers t2)))

(day-answers 
  5 
  (apply min (map car (composed-layers t1)))
  (apply min (map car (composed-layers t2))))
