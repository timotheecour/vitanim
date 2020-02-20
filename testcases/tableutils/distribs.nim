import std/[random, oids, strutils]

proc toRand*(a: int): int = rand(int.high)
proc toRandSigned*(a: int): int =
  result = rand(int.high) - (int.high div 2)
proc toRand2*(a: int): int = genOid().hash
proc rand3(): cint {.importc: "rand", header: "<stdlib.h>", nodecl.}
proc toRand3*(a: int): int = rand3()
proc toRandFloat*(a: int): float =
    result = rand(1.0)

proc toRandFloatAsString*(a: int): string = $rand(1.0)
proc intAsString*(a: int): string = $a
proc randIint32AsString*(a: int): string = $rand(int.high)
proc oidHash*(a: int): auto = genOid().hash
proc oidHashAsString*(a: int): string = $genOid()

proc toInt64*(a: int): int64 = cast[int64](a)
proc toInt32*(a: int): int32 = cast[int32](a)
proc toIntTimes13*(a: int): int = a * 13
proc toIntTimes5*(a: int): int = a * 5

proc toRandInt32*(a: int): int32 = cast[int32](rand(int32.high))
proc toHighOrderBits*(a: int): uint64 = cast[uint64](a) shl 32
proc toHighOrderBitsInt32*(a: int): uint32 = cast[uint32](a) shl 16

proc toHighOrderBits2*(a: int): uint32 = cast[uint32](a*2048)
proc toHighOrderBits3*(a: int): uint = cast[uint](a*2048*4)
proc toHighOrderBitsTimesSmall*(a: int): uint32 = cast[uint32](a*64)


proc toEnglishWords*(a: int): string =
  var words {.threadvar.}: seq[string]
  if words.len == 0:
    # TODO: automatically download / unzip from http://www.ccs.neu.edu/home/sbratus/com1101/words.zip
    let file = "/Users/timothee/Downloads/usr/dict/words"
    words = file.readFile.splitLines
  let index = a mod words.len
  let period = a div words.len
  result = words[index] & "_" & $period

proc toSmallFloat*(a: int): float =
  result = a.float*1e-20

proc toSquares*(a: int): int = a*a
proc toSquaresSigned*(a: int): int =
  if a mod 2 == 0:
    toSquares(a)
  else:
    -toSquares(a)

proc toSquaresLike*(a: int): int32 = cast[int32](a*a+1)

proc randomizeAux*()=
  randomize(1234)
