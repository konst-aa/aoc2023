(module aoc-lib
  (day-answers
    make-box
    set-box!
    get-box
    prune-empty
    sp-split
    sp-split-n
    pre-colon
    colon
    lines
    section
    range
    incl-range
    char->number
    nd-get
    flatmap
    vector-apply
    vector-flatmap
    digit?
    boolean->number
    list->number
    all?
    any?
    sum
    read-line
    read-all
    make-string-port
    make-make-file-port
    group-two
    curry-apply
    curried-lambda
    define-curried)

  (import scheme
          (srfi 1)
          (srfi 152)
          vector-lib
          (chicken base)
          (chicken format)
          (chicken port))

  (define (day-answers day p1 p2)
    (printf "=Day ~A=\n" day)
    (print "p1: " p1)
    (print "p2: " p2)
    (newline))

  (define (make-box value)
    (list value))
  (define (set-box! box new-value)
    (set-car! box new-value))
  (define (get-box box)
    (car box))

  (define (prune-empty str-lst)
    (filter (lambda (s) (not (equal? s ""))) str-lst))

  (define (sp-split str)
    (prune-empty (string-split str " ")))

  (define (sp-split-n str)
    (map string->number (sp-split str)))

  (define (pre-colon str)
    (car (string-split str ":")))

  (define (colon str)
    (cadr (string-split str ":")))

  (define (lines str)
    (prune-empty (string-split str "\n")))

  (define (section str)
    (string-split str "\n\n"))

  (define (range n m step)
    (define (helper n acc)
      (if (< n m)
        (helper (+ n step) (cons n acc))
        acc))
    (reverse
      (if (<= n m)
        (helper n (list))
        (range m n (- step)))))

  (define (incl-range n m step)
    (if (> n m)
      (range (+ n 1) m step)
      (range n (+ m 1) step)))

  (define (char->number char)
    (string->number (list->string (list char))))

  (define-syntax nd-get
    (syntax-rules ()
      ((_ vec i)
       (vector-ref vec i))
      ((_ vec i j ...)
       (nd-get (vector-ref vec i) j ...))))

  (define (vector-apply fn vec)
    (apply fn (vector->list vec)))

  (define (vector-flatmap fn vec)
    (vector-apply vector-append (vector-map fn vec)))

  (define (flatmap fn lst)
    (apply append (map fn lst)))

  (define (digit? char)
    (number? (char->number char)))

  (define (boolean->number boolean)
    (if boolean 1 0))

  (define list->number (compose string->number list->string))

  (define (all? lst)
    (foldl (lambda (a b) (and a b)) #t lst))
  (define (any? lst)
    (foldl (lambda (a b) (or a b)) #f lst))

  (define (sum lst)
    (foldl + 0 lst))

  (define (read-line port)
    (define (helper acc)
      (let ((curr (read-char port)))
        (cond
          ((eof-object? curr)
           (if (null? acc)
             #!eof
             (list->string (reverse acc))))
          ((eq? curr #\newline) (list->string (reverse acc)))
          (else (helper (cons curr acc))))))
    (helper (list)))

  (define (read-all port)
    (define (helper acc)
      (let ((curr (read-char port)))
        (if (eof-object? curr)
          (list->string (reverse acc))
          (helper (cons curr acc))
          )))
    (helper (list)))

  (define (make-string-port str)
    (call-with-input-string str identity))

  (define (make-make-file-port filename)
    (lambda () (make-string-port (read-all (open-input-file filename)))))

  (define (group-two a b . args)
    (cons (list a b)
          (if (null? args)
            (list)
            (apply group-two args))))

  (define (curry-apply fn a1 . rest)
    (if (null? rest)
      (fn a1)
      (apply curry-apply (cons (fn a1) rest))))

  (define-syntax curried-lambda
    (syntax-rules ()
      ((_ () def ...)
       (begin def ...))
      ((_ (arg rest ...) def ...)
       (lambda (a1 . argl)
         (apply curry-apply
                (lambda (arg) (curried-lambda (rest ...) def ...))
                (cons a1 argl))))))

  (define-syntax define-curried
    (syntax-rules ()
      ((_ (name args ...) impl ...)
       (define name (curried-lambda (args ...) impl ...)))))
  )
