(import aoc-lib
        vector-lib ; clam 9
        (srfi 1)   ; lists
        (srfi 113) ; sets
        (srfi 128) ; comparators
        (srfi 132) ; sorting
        (srfi 152) ; string-lib
        )

; (define inp (read-all (open-input-file (string-append "07/sample.txt"))))
(define inp (read-all (open-input-file (string-append "07/input.txt"))))

(define rows (lines inp))
(define (row->hand row)
  (let ((t (string-split row " ")))
    (cons (string->list (car t)) (string->number (cadr t)))))

(define hands (map row->hand rows))

(define (lst->bg lst)
  (list->bag (make-default-comparator) lst))

(define (hand-bag->count-bag1 hand-bag)
  (let ((hand-alist (bag->alist hand-bag)))
    (lst->bg (map cdr hand-alist))))

(define (hand-bag->count-bag2 hand-bag)
  (define (fold-fn item n acc)
    (if (> n (cdr acc))
      (cons item n)
      acc))
  (let* ((jokers (bag-element-count hand-bag #\J))
         (hand-bag (bag-remove (lambda (c) (eq? c #\J)) hand-bag))
         (highest (bag-fold-unique fold-fn (cons #\O 0) hand-bag))
         )
    (bag-increment! hand-bag (car highest) jokers)
    ; (bag-increment! hand-bag #\J jokers)
    (lst->bg (map cdr (bag->alist hand-bag)))))

(define-curried (hand-type hand-bag->count-bag hand)
  (let* ((hand-bag (lst->bg hand))
         (count-bag (hand-bag->count-bag hand-bag)))
    (cond
      ((= (bag-element-count count-bag 5) 1) 6)
      ((= (bag-element-count count-bag 4) 1) 5)
      ((and (= (bag-element-count count-bag 3) 1)
            (= (bag-element-count count-bag 2) 1))
       4)
      ((= (bag-element-count count-bag 3) 1) 3)
      ((= (bag-element-count count-bag 2) 2) 2)
      ((= (bag-element-count count-bag 2) 1) 1)
      (else 0))))

(define spec-mapping
  (list (cons #\A 14)
        (cons #\K 13)
        (cons #\Q 12)
        ; (cons #\J 11)
        (cons #\T 10)))

(define-curried (c->score spec-mapping c)
  (if (char->number c)
    (char->number c)
    (alist-ref c spec-mapping)))

(define c->score1 
  (c->score (cons (cons #\J 11) spec-mapping)))

(define c->score2
  (c->score (cons (cons #\J 0) spec-mapping)))

(define-curried (le? c->score hand-type handl handr)
  (define (fold-fn acc lr)
    (let ((l (car lr))
          (r (cdr lr)))
      (cond
        ((car acc) acc)
        (l (cons #t #t))
        (r (cons #t #f))
        (else acc))))
  (let* ((handl (car handl))
         (handr (car handr))
         (tl (hand-type handl))
         (tr (hand-type handr))
         (rl (map c->score handl))
         (rr (map c->score handr))
         (fst-le (map < rl rr))
         (snd-le (map > rl rr))
         (te (map cons fst-le snd-le)))
    (if (not (= tl tr))
      (< tl tr)
      (cdr (foldl fold-fn (cons #f 'nil) te)))))


(define (solve le?)
  (define (map-fn a b)
    (* (cdr a) b))
  (let ((sorted (list-sort le? hands))
        (ranks (incl-range 1 (length hands) 1)))
    (sum (map map-fn sorted ranks))))

(day-answers
  7
  (solve (le? c->score1 (hand-type hand-bag->count-bag1)))
  (solve (le? c->score2 (hand-type hand-bag->count-bag2))))
