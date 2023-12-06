(import aoc-lib
        (chicken string))


(define input-file (open-input-file "02/input.txt"))

(define (round-string->round-tuple round-string)
  (let ((color-tuples (apply group-two (string-split round-string " ,"))))
    (map (lambda (lst)
           (let ((color-num (string->number (car lst)))
                 (color-sym (string->symbol (cadr lst))))
             (cons color-sym color-num)))
         color-tuples)))

(define-curried (get-col col color-tuple)
  (alist-ref col color-tuple eq? 0))

(define getr (get-col 'red))
(define getg (get-col 'green))
(define getb (get-col 'blue))

(define (verify-color-tuple color-tuple)
  (and (<= (getr color-tuple) 12)
       (<= (getg color-tuple) 13)
       (<= (getb color-tuple) 14)))

(define (sol1 game-id round-tuples)
  (if (all? (map verify-color-tuple round-tuples))
    game-id
    0))

(define (sol2 round-tuples)
  (define (fold-fn acc item)
    (list (cons 'red (max (getr acc) (getr item)))
          (cons 'green (max (getg acc) (getg item)))
          (cons 'blue (max (getb acc) (getb item)))))
  (let* ((init-acc (list (cons 'red 0) (cons 'blue 0) (cons 'green 0)))
         (biggest (foldl fold-fn init-acc round-tuples)))
    (* (getr biggest) (getg biggest) (getb biggest))))

(define (driver acc)
  (let ((line (read-line input-file)))
    (if (eof-object? line)
      acc
      (let* ((acc1 (car acc))
             (acc2 (cdr acc))
             (s1 (string-split line ":"))
             (game-id (string->number (cadr (string-split (car s1) " "))))
             (rounds (string-split (cadr s1) ";"))
             (round-tuples (map round-string->round-tuple rounds))
             (res1 (sol1 game-id round-tuples))
             (res2 (sol2 round-tuples)))
        (driver (cons (+ acc1 res1) (+ acc2 res2)))))))

(define res (driver (cons 0 0)))

(day-answers 2 (car res) (cdr res))
