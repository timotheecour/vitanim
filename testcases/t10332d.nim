#[
D20200310T030123

snippet showing that

    for c in mitems(s):
      # faster than `if c.isUpperAscii: ...`
      c = chr(c.ord + (if c.isUpperAscii: (ord('a') - ord('A')) else: 0))

is 11X faster than:

    for c in mitems(s):
      if c in {'A'..'Z'}: c = chr(ord(c) + (ord('a') - ord('A')))

]#
include system/timers
import std/strutils

proc main()=
  var x = 0
  let n = 10_000_000
  let m = 1000
  var s = newString(m)

  var dt = 0.Nanos
  for i in 0..<n:

    # shuffles input to prevent artificial branch predictor optimzations
    for j in 0..<m:
      s[j] = cast[char]('A'.ord + ((i *% j) mod ('z'.ord - 'A'.ord + 1)))

    let t = getTicks()
    toLowerAsciiInplace(s)
    let t2 = getTicks()
    dt += t2-t
    x+=ord(s[^1]) + s.len # prevent optimizing out
  doAssert x > 0
  echo dt.float*1e-9
main()
