#lang racket

(require 2htdp/universe 2htdp/image)

; A representation of the world's state.
; x         - Integer x position of the tank.
; direction - Boolean direction of the tank (true means right and false
;             means left).
(struct world (x direction) #:transparent)

(define WIDTH 500)
(define HEIGHT 300)
(define IMAGE (bitmap/file "tank64.png"))
(define HALF-WIDTH (/ (image-width IMAGE) 2))
(define HALF-HEIGHT (/ (image-height IMAGE) 2))
(define RIGHT true)
(define LEFT false)
(define SPEED 5)

; world -> world
(define (update-tank w)
  (define new-dir (update-direction w))
  (define new-x (update-position new-dir (world-x w)))
  (world new-x new-dir))

; world -> boolean
(define (update-direction w)
  (cond [(tank-hit-right? w) (set! IMAGE (flip-horizontal IMAGE)) LEFT]
        [(tank-hit-left? w) (set! IMAGE (flip-horizontal IMAGE)) RIGHT]
        [else (world-direction w)]))

; boolean integer -> integer
(define (update-position direction x)
  (if direction
    (+ x SPEED)
    (- x SPEED)))

; world -> boolean
(define (tank-hit-right? w)
  (and (world-direction w) (>= (world-x w) (- WIDTH HALF-WIDTH))))

; world -> boolean
(define (tank-hit-left? w)
  (and (not (world-direction w)) (<= (world-x w) HALF-WIDTH)))

; world -> ?
(define (draw-tank-onto-empty-scene w)
  (place-image IMAGE (world-x w) (- HEIGHT HALF-HEIGHT)
               (empty-scene WIDTH HEIGHT)))

(big-bang (world HALF-WIDTH RIGHT)
          (on-tick update-tank)
          (to-draw draw-tank-onto-empty-scene))
          

