(import aoc-lib
        (chicken string))

(define make-fport (make-make-file-port "01/input.txt"))

(define (driver acc preprocess port)
  (let ((line (read-line port)))
    (if (eof-object? line)
      acc
      (let* ((t (preprocess line))
             (digit-strings (string-split t "abcdefghijklmnopqrstuvwxyz"))
             (charlist (string->list (apply string-append digit-strings)))
             (fst (car charlist))
             (lst (car (reverse charlist))))
        (driver (+ acc (string->number (list->string (list fst lst))))
                preprocess
                port)))))

(define (replace-digits line)
  (define word-digit-smap
    ;; krill issue
    ;; https://www.reddit.com/r/adventofcode/comments/1883ibu/comment/kbj2stu/
    (list
      (cons "one" "o1e")
      (cons "two" "t2o")
      (cons "three" "t3e")
      (cons "four" "f4r")
      (cons "five" "f5e")
      (cons "six" "s6x")
      (cons "seven" "s7n")
      (cons "eight" "e8t")
      (cons "nine" "n9e")))

  (foldl (lambda (acc item)
           (string-translate* acc (list item)))
         line
         word-digit-smap))

(day-answers
  1
  (driver 0 identity (make-fport))
  (driver 0 replace-digits (make-fport)))
