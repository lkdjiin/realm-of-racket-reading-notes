#lang racket

(require 2htdp/universe 2htdp/image)

(struct interval (small big guess-num) #:transparent)

(define TEXT-SIZE 14)
(define HELP-TEXT
  (text "↑ for larger number, ↓ for smaller ones"
        TEXT-SIZE
        "blue"))
(define HELP-TEXT2
  (text "Press = when your number is guessed; q to quit."
        TEXT-SIZE
        "blue"))
(define WIDTH (+ (image-width HELP-TEXT2) 10))
(define HEIGHT 250)
(define COLOR "red")
(define TEXT-X 3)
(define TEXT-UPPER-Y 10)
(define TEXT-LOWER-Y 205)
(define SIZE 75)
(define MT-SC
  (place-image/align
    HELP-TEXT TEXT-X TEXT-UPPER-Y "left" "top"
    (place-image/align
      HELP-TEXT2 TEXT-X TEXT-LOWER-Y "left" "bottom"
      (empty-scene WIDTH HEIGHT))))

(define (start lower upper)
  (big-bang (interval lower upper 1)
            (on-key deal-with-guess)
            (to-draw render)
            (stop-when single? render-last-scene)))

(define (deal-with-guess w key)
  (cond [(key=? key "up") (bigger w)]
        [(key=? key "down") (smaller w)]
        [(key=? key "q") (stop-with w)]
        [(key=? key "=") (stop-with w)]
        [else w]))

(define (smaller w)
  (interval (interval-small w)
            (max (interval-small w) (sub1 (guess w)))
            (add1 (interval-guess-num w))))

(define (bigger w)
  (interval (min (interval-big w) (add1 (guess w)))
            (interval-big w)
            (add1 (interval-guess-num w))))

(define (guess w)
  (quotient (+ (interval-small w) (interval-big w)) 2))

(define (render w)
  (place-image
    (text (guess-num->string w) 20 COLOR) (/ WIDTH 2) 50
    (overlay
      (text (number->string (guess w)) SIZE COLOR)
      MT-SC)))

(define (guess-num->string w)
  (string-append "Guess # " (number->string (interval-guess-num w))))

(define (render-last-scene w)
  (overlay (text "End" SIZE COLOR) MT-SC))

(define (single? w)
  (= (interval-small w) (interval-big w)))


(start 1 100)
