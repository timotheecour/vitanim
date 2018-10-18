import typetraits
#[ 
TODO:
compared to D, use any instead of empty

isInputRange concept

how to make map's `fun` templated insead of overhead of a delegate?

isForwardRange (w save)

foreach

benchmark runtime speed
benchmark compilation time

NOTE:
on error 'too nested for type matching'
requires:
if prevMatchedConcept.depth > 10:
in sigmatch.nim

slow with deeper expression

]#

type 
  isInputRange* = concept x
    x.notEmpty is bool
    not(x.front is void)
    # TODO
    # x.popFront() is void
    x.popFront

## map
type 
  MapObj*[R:isInputRange, Fun]=object
    r:R
    # TODO: is that as efficient as in D? case of function vs delegate vs lambda
    fun:Fun

  isMapObj* = concept a
    a is MapObj[a.R, a.Fun]

proc map*[R, Fun](r:R, fun:Fun):auto = MapObj[R,Fun](r:r, fun:fun)

#TODO: can we do w proc? would need to pull in proc's defined where x is defined as done in D; not sure if possible in Nim
template notEmpty*(a:isMapObj):bool = a.r.notEmpty
template popFront*(a:var isMapObj) = a.r.popFront
template front*(a:isMapObj):auto = a.fun(a.r.front)

## filter
type 
  FilterObj*[R:isInputRange, Fun]=object
    r:R
    fun:Fun
    primed:bool

  isFilterObj* = concept a
    a is FilterObj[a.R, a.Fun]

proc filter*[R, Fun](r:R, fun:Fun):auto = FilterObj[R,Fun](r:r, fun:fun, primed:false)

template prime*(a:var isFilterObj):void =
  if a.primed.not:
    while a.r.notEmpty and a.fun(a.r.front).not:
      a.r.popFront
    a.primed=true

template notEmpty*(a:var isFilterObj):bool = 
  a.prime
  a.r.notEmpty

template popFront*(a:var isFilterObj) =
  while true:
    a.r.popFront
    if a.r.notEmpty.not or a.fun(a.r.front):
      break
  a.primed=true

template front*(a:var isFilterObj):auto =
  a.prime
  a.r.front

## take
type 
  TakeObj*[R:isInputRange]=object
    r:R
    n:int
    count:int

  isTakeObj* = concept a
    a is TakeObj[a.R]

proc take*[R](r:R, n:int):auto = TakeObj[R](r:r, n:n, count:0)

template notEmpty*(a:isTakeObj):bool = a.count < a.n and a.r.notEmpty

template popFront*(a:var isTakeObj) =
  a.r.popFront
  a.count.inc

template front*(a:var isTakeObj):auto = a.r.front

##
template toIter*(a: isInputRange): auto =
  (iterator (): a.front.type {.closure.} =
    while a.notEmpty:
      yield a.front
      a.popFront
  )

template toArray*(a:isInputRange):auto=
  type E=a.front.type
  var ret:seq[E]
  while a.notEmpty:
    ret &= a.front
    a.popFront
  ret
