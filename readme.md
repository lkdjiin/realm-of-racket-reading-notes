Realm of Racket
=====================================

This is my reading notes for the book «Realm of Racket».

All images are from [Game-icons.net](http://game-icons.net/).

Chapter 2
---------
The «guess my number» game: chapter2/guess.rkt

Chapter 4
---------
### page 54

It seems that without the `#:transparent` argument in a `struct` definition,
one cannot test two structs for equality:

    -> (struct student (name id# dorm))
    -> (equal? (student 'Joe 1234 'NewHall) (student 'Joe 1234 'NewHall))
    #f
    -> (struct student (name id# dorm) #:transparent)
    -> (equal? (student 'Joe 1234 'NewHall) (student 'Joe 1234 'NewHall))
    #t

Chapter 5
---------

To load an image, use `bitmap/file`, path is relative:

```racket
(define IMAGE (bitmap/file "tank.png"))
```

Function `place-image` place an image relatively to its center, not to
upper-left corner!

- The ufo program: chapter5/ufo.rkt
- The «guess my number» GUI game: chapter5/guess-gui.rkt
- Chapter challenges:
  * Easy: chapter5/tank.rkt
  * Medium: chapter5/guess-gui2.rkt
  * Difficult: chapter5/ufo2.rkt
