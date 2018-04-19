 #lang racket
;Q 1
(define (null-ld? obj)
  (if( and (pair? obj)(empty? obj)) #t
     	(eq? (car obj) (cdr obj))))

;Q2
(define (ld? obj)
(cond
	[(not (pair? obj)) #f]
	[(null-ld? obj) #t]
	[(eq? (car obj) (cdr obj)) #t]
	[(not (pair? (car obj))) #f]
	[#t (ld? (cons (cdr (car obj)) (cdr obj)))]))

(define (listdiff? obj)
(cond
	[(not (pair? obj)) #f]
	[(null-ld? obj) #t]
	[(eq? (car obj) (cdr obj)) #t]
	[(not (pair? (car obj))) #f]
	[#t (ld? (cons (cdr (car obj)) (cdr obj)))]))

;Q3
(define (cons-ld obj listdiff)
  (cons (cons obj (car listdiff)) (cdr listdiff)))

;Q4
(define (car-ld listdiff)
	(cond
  		[(and (not (null-ld? listdiff)) (listdiff? listdiff)) (car (car listdiff))]
	 	[else (display "error\n")]))
;Q5
(define (cdr-ld listdiff)
	(cond
  		[(and (not (null-ld? listdiff)) (listdiff? listdiff)) (cons (cdr (car listdiff)) (cdr listdiff))]
	 	[else (display "error\n")]))
;Q6
(define (ld . obj) (cons obj '()))

;Q7
(define (length-ld-tail listdiff total-length)
	(cond
		((not (listdiff? listdiff)) (display "error\n"))
		(else
			(if (null-ld? listdiff)
				total-length
			(length-ld-tail (cdr-ld listdiff) (+ total-length 1))))))

(define (length-ld listdiff)
	(length-ld-tail listdiff 0))

;Q8
(define f
  (lambda (args)
    (car args)))

(define f1
  (lambda (args)
    (cdr args)))


(define (append-ld listdiff . args)
	(if (not(null? args)) 
		(apply append-ld (cons 
				(append (take (f listdiff) (length-ld listdiff)) 
	  					(f (f args))) 
						(f1 (f args))) 
	  					(f1 args))
		listdiff))


;Q9
(define (ld-tail listdiff k)
	(if
		(< k 0) (display "error\n")
			(if 
				(> k (length-ld listdiff)) (display "error\n")
					(if
						(= k 0) listdiff (ld-tail (cons (cdr (car listdiff)) (cdr listdiff)) (- k 1))))))

;Q10
(define (list->ld list)
  (if (not (list? list))
      (display "error\n")
      (apply ld (car list) (cdr list))))

;Q11
(define (ld->list listdiff)
	(if (eq? (car listdiff) (cdr listdiff)) '()  (cons 
		(car (car listdiff)) 
		(ld->list (cons (cdr (car listdiff)) 
		(cdr listdiff))))))

;Q12
;Q13


;====Test case ===
; (define ils (append '(a e i o u) 'y))
; (define d1 (cons ils (cdr (cdr ils))))
; (define d2 (cons ils ils))
; (define d3 (cons ils (append '(a e i o u) 'y)))
; (define d4 (cons '() ils))
; (define d5 0)
; (define d6 (ld ils d1 37))
; (define d7 (append-ld d1 d2 d6))
; (define kv1 (cons d1 'a))
; (define kv2 (cons d2 'b))
; (define kv3 (cons d3 'c))
; (define kv4 (cons d1 'd))
; (define d8 (ld kv1 kv2 kv3 kv4))
; (define d9 (ld kv3 kv4))


; ;=====Test case perform
; (ld? d1)
; (ld? d2)
; (ld? d3)
; (ld? d4)
; (ld? d5)
; (ld? d6)
; (ld? d7)

; (null-ld? d1)
; (null-ld? d2)
; (null-ld? d3)
; (null-ld? d6)

; (car-ld d1) 
; (car-ld d2) 
; (car-ld d3) 
; (car-ld d6) 

; (length-ld d1)
; (length-ld d2)
; (length-ld d3)
; (length-ld d6)
; (length-ld d7)

; (eq? d8 (ld-tail d8 0))
; (equal? (ld->list (ld-tail d8 2))
;         (ld->list d9))
; (null-ld? (ld-tail d8 4)) 
; (ld-tail d8 -1)
; (ld-tail d8 5) 
; (eq? (car-ld d6) ils)
; (eq? (car-ld (cdr-ld d6)) d1)
; (eqv? (car-ld (cdr-ld (cdr-ld d6))) 37)
; (equal? (ld->list d6)
;         (list ils d1 37))
; (eq? (list-tail (car d6) 3) (cdr d6))             

;====Extra test case
; (cdr-ld d1)     
; (cdr-ld d2)     
; (cdr-ld d3)     
; (cdr-ld d6)  

;======CAR ======
;(car-ld d1)                            ⇒  a
;(car-ld d2)                            ⇒  error
;(car-ld d3)                            ⇒  error
;(car-ld d6)                            ⇒  (a e i o u . y)

;=======CDR=====
;(cdr-ld d1)      ==> '((e i o u . y) i o u . y)
;(cdr-ld d2)      ==> error
;(cdr-ld d3)      ==> error
;(cdr-ld d6)      ===> ((((a e i o u . y) i o u . y) 37))

