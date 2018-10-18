import std/[
  typetraits,
  sugar,
  unittest,
]

import drange
import sequtils

## tests
proc testFun()=
  var a=Iota(n:10)

  block:
    var temp = toSeq(a.toIter()())
    doAssert temp == @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  block:
    var temp = toSeq(a.toIter()())
    doAssert temp == @[]

  a=Iota(n:10)
  doAssert a.toArray == @[0, 1, 2, 3, 4, 5, 6, 7, 8, 9]

  proc myfilter(x:int):auto = x mod 2 == 0

  var b2=Iota(n:100).
    map((x:int)=>x*2).
    # filter(myfilter).
    take(5)

  doAssert b2.toArray == @[0, 2, 4, 6, 8]

test "test1":
  testFun()

test "test1":
  testFun()

when defined(case1):
  # [blocker for implementing D ranges in Nim · Issue #9422 · nim-lang/Nim](https://github.com/nim-lang/Nim/issues/9422)
  test "test_fail":
    var b2=Iota(n:100).
      map((x:int)=>x*2).
      map((x:int)=>x*2).
      # map((x:int)=>x*2).
      take(5)

    echo b2.toArray

when defined(case2):
  # 10 seconds with WORKAROUND from https://github.com/nim-lang/Nim/issues/9422
  test "test_fail2":
    var b2=Iota(n:100).
      map((x:int)=>x*2).
      map((x:int)=>x*2).
      map((x:int)=>x*2).
      take(5)

    echo b2.toArray

when defined(case3):
  # 107 seconds with WORKAROUND from https://github.com/nim-lang/Nim/issues/9422
  test "test_fail3":
    var b2=Iota(n:100).
      map((x:int)=>x*2).
      map((x:int)=>x*2).
      map((x:int)=>x*2).
      map((x:int)=>x*2).
      take(5)

    echo b2.toArray
