#lang racket

(require 2htdp/universe 2htdp/image)

(struct smoke (x y size) #:transparent)
(struct world (x y smokes) #:transparent)

(define WIDTH 600)
(define HEIGHT 600)
(define SPEED 10)
(define IMAGE-of-UFO (bitmap/file "jet-pack64.png"))

(define (smoke-positive-size? s)
  (positive? (smoke-size s)))

(define (update-position w key)
  (cond [(key=? key "up") (move-up w)]
        [(key=? key "down") (move-down w)]
        [(key=? key "right") (move-right w)]
        [(key=? key "left") (move-left w)]
        [(key=? key "q") (stop-with w)]
        [else w]))

(define (update-smokes w)
  (define this-smoke (smoke (world-x w) (world-y w) 30))
  (define new-smokes 
    (filter smoke-positive-size?
      (map 
        (λ(n) (smoke (smoke-x n) (smoke-y n) (- (smoke-size n) 1)))
        (world-smokes w))))
  (cons this-smoke new-smokes))

(define (move-up w)
  (world (world-x w) (- (world-y w) SPEED) (update-smokes w)))

(define (move-down w)
  (world (world-x w) (+ (world-y w) SPEED) (update-smokes w)))

(define (move-right w)
  (world (+ (world-x w) SPEED) (world-y w) (update-smokes w)))

(define (move-left w)
  (world (- (world-x w) SPEED) (world-y w) (update-smokes w)))

(define (render w)
  (place-image IMAGE-of-UFO (world-x w) (world-y w)
               (render-smokes (world-smokes w) (empty-scene WIDTH HEIGHT))))

; list<smokes> image -> image
(define (render-smokes smokes img)
  (if (empty? smokes)
    img
    (render-smokes
      (rest smokes)
      (place-image (circle (smoke-size (first smokes)) 'outline "gray")
                   (smoke-x (first smokes))
                   (smoke-y (first smokes))
                   img))))

(big-bang (world (/ WIDTH 2) (/ HEIGHT 2) empty)
          (on-key update-position)
          (to-draw render))
