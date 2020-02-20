#[
D20200219T132255
]#
import std/[strformat]
import "."/distribs
import "."/benchutils
import "."/utils

var index = 0

template runPerfAux(fun2) =
  index.inc

  let numIter = 1
  let timeout = 50.0
  let num = 20_000_000

  # let numIter = 1
  # let timeout = 20.0
  # # let num = 5_000_000
  # let num = 1_000_000

  # workaround for BUG Nim: this would cause: Error: type mismatch: got <proc (a: int): int{.gcsafe, locks: 0.}> but expected 'proc (
  # let data = Data[typeof(fun)](index: index, fun: fun, name: astToStr(fun2), num: num, numIter: 4, enableGetNonexistant: true, enableGet: true, timeout: timeout)
  block:
    proc myfun(i: int): auto =
      {.noSideEffect.}: fun2(i)
    let data = Data[typeof(myfun)](index: index, fun: myfun, name: astToStr(fun2), num: num, numIter: numIter, enableGetNonexistant: true, enableGet: true, timeout: timeout)
    # let data = Data[typeof(myfun)](index: index, fun: myfun, name: astToStr(fun2), num: num, numIter: numIter, enableGetNonexistant: false, enableGet: false, timeout: timeout)
    runPerf(data)

proc runPerfAll =
  let ghash = getNimGitHash()
  echo fmt"runPerfAll benchmark for nim git hash: {ghash}"

  ## string keys
  runPerfAux(toEnglishWords)
  runPerfAux(toRandFloatAsString)
  runPerfAux(oidHash)
  runPerfAux(oidHashAsString)
  runPerfAux(randIint32AsString)
  runPerfAux(intAsString)

  ## consecutive integers
  runPerfAux(toInt32)
  runPerfAux(toInt64)

  ## fixed formula
  runPerfAux(toSquares)
  runPerfAux(toSquaresSigned)
  runPerfAux(toIntTimes5)
  runPerfAux(toIntTimes13)

  ## random
  runPerfAux(toRand)
  runPerfAux(toRandFloat)

  ## edge case: small floats
  runPerfAux(toSmallFloat)

  ## high order bits
  runPerfAux(toHighOrderBits)
  runPerfAux(toHighOrderBits2)
  runPerfAux(toHighOrderBits3)

runPerfAll()
