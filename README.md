# Hall Algebras in GAP 

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

Some [GAP](https://github.com/gap-system/gap) functions to calculate the Hall algebra 
of a quiver algebra generated by [QPA](https://github.com/gap-packages/qpa).

Right now the most useful function is `HallNumber(A,B,X)` which, for a fixed `q`,
computes the Hall number for the short exact sequence 0 → B → X → A → 0.


## TODO

  - **Ultimate Goal** Write it to where, for a finite-type bound quiver,
  I can literally get an 
  [associative algbera](https://www.gap-system.org/Manuals/doc/ref/chap62.html#X7CC58DFD816E6B65) 
  object in GAP that is the Hall algebra of the quiver, 
  and maybe so I can compare this algebra to some quantum groups using
  [QuaGroup](https://github.com/gap-packages/quagroup)

  - First, finish the `HallPolynomial()` function.
  Look at the error being returned for `HallPolynomial(S1,S2,S1S2)`.
  I'm not sure the best way to "change" `q` for this.

  - Many of the functions could be sped up by taking an optional argument
  of the (finite) list of indecomposable modules over a path algebra.
  So I could also write a function that calculates the indecomposables,
  at least the ones generated as extensions of simple objects.
  For which bound quivers will doing this get all the indecomposables?

  - **Testing** Working with the function `HallNumber()` on quivers that I'm familiar with, 
  I'm convinced it is correct, BUT it would be nice to have some tests to verify that it works.
    
