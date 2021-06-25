#[
D20210623T014358
]#

import std/private/digitsutils

proc addInt1(target: var string, x: uint64) =
  const digit = "0123456789"          # maybe set elsewhere already
  var buf {.noInit.}: array[20, char] # ceil(log_10(2^64 - 1)) == 20
  var x = x                           # changing perms on `x`
  var i = buf.len - 1                 # work from back of buf to front
  while x >= 10:
    buf[i] = digit[x mod 10]  # extract digit into temp array
    x = x div 10
    dec i
  buf[i] = digit[x mod 10]
  x = x div 10                # No final dec; buf[i] is now leading digit
  let n = target.len          # a couple trivial abstractions
  let m = buf.len - i         # could also just target.add buf[i..^1]
  target.setLen n + m         # this all works in base-100, too
  copyMem target[n].addr, buf[i].addr, m

proc addInt2(result: var string; x: uint64) =
  let length = digits10(x)
  setLen(result, result.len + length)
  addIntImpl(result, x, result.len - length)

import std/times

var c0 = 0

template mainAux(algo) =
  var s = ""
  let t = cpuTime()
  let n = 10000_0000
  var c = 0
  const M = (1 shl 32) - 1
  var x = 7'u64
  var j = 1
  for i in 0..<n:
    when true:
      # pseudo-random in 0..M
      x = (5 * x) and M
    when false:
      # pseudo-random variant 2
      var x = cast[uint64](i)
      x = x + (x*x shl 5)
    when false:
      # pseudo-random with small number bias
      x = (5 * x) and (1'u64 shl j) - 1
      j.inc
      if j > 50: j = 1

    s.setLen(0)
    algo(s, x)

    when false:
      if i < 70:
        echo s
    c+=s.len
  let t2 = cpuTime()
  echo (t2 - t, astToStr(algo), c)
  if c0 == 0:
    c0 = c
  else:
    doAssert c == c0

proc main =
  for i in 0..<3:
    echo()
    mainAux(addInt1)
    mainAux(addInt2)
main()
