#[
D20200219T132255
]#
import std/[strformat]
import std/[tables] # PRTEMP D20200220T013017:here
import "."/distribs
import "."/benchutils
import "."/utils

var index = 0

template runPerfAux(fun2) =
  index.inc

  ## large test
  # let numIter = 1
  # let timeout = 500.0
  # let num = 100_000_000

  ## test to publish
  let numIter = 1
  let timeout = 50.0
  let num = 20_000_000

  # scratch
  # let numIter = 1
  # let timeout = 20.0
  # let num = 1_000_000

  # workaround for BUG Nim: this would cause: Error: type mismatch: got <proc (a: int): int{.gcsafe, locks: 0.}> but expected 'proc (
  # let data = Data[typeof(fun)](index: index, fun: fun, name: astToStr(fun2), num: num, numIter: 4, enableGetNonexistant: true, enableGet: true, timeout: timeout)
  block:
    proc myfun(i: int): auto =
      {.noSideEffect.}: fun2(i)
    let data = Data[typeof(myfun)](index: index, fun: myfun, name: astToStr(fun2), num: num, numIter: numIter, enableGet: true, timeout: timeout)
    runPerf(data)

proc runPerfAll =
  let ghash = getNimGitHash()
  echo fmt"runPerfAll benchmark for nim git hash: {ghash}"

  ## scratch
  # runPerfAux(toRand)
  # runPerfAux(toHighOrderBits)
  # runPerfAux(toEnglishWords)
  # runPerfAux(toSquares)
  # if true: return

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
