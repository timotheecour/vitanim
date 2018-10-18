import drange

## Iota
type
  Iota* = object
    n*: int
    i*: int

proc notEmpty*(a:Iota):bool=a.i < a.n
proc popFront*(a:var Iota)=a.i.inc
proc front*(a:Iota):auto=a.i

