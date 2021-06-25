#[
D20210623T014358

benchmark for https://github.com/nim-lang/Nim/pull/18324
nim r -d:danger $vitanim_D/testcases/t10977b.nim
results on OSX 11.4, 2.3 GHz 8-Core Intel Core i9:

addInt0
(time: 3.917106, alg: "addInt0", mode2: 1, sanity: 6057706836)
(time: 4.389234999999999, alg: "addInt0", mode2: 2, sanity: 6823134569)
(time: 4.067030000000001, alg: "addInt0", mode2: 3, sanity: 5913000000)

addInt1
(time: 2.4893790000000013, alg: "addInt1", mode2: 1, sanity: 6057706836)
(time: 3.3688249999999993, alg: "addInt1", mode2: 2, sanity: 6823134569)
(time: 2.395979999999998, alg: "addInt1", mode2: 3, sanity: 5913000000)

addInt3
(time: 1.7892239999999973, alg: "addInt3", mode2: 1, sanity: 6057706836)
(time: 2.0433079999999997, alg: "addInt3", mode2: 2, sanity: 6823134569)
(time: 1.7770119999999991, alg: "addInt3", mode2: 3, sanity: 5913000000)

addIntDigits10
(time: 1.513846000000001, alg: "addIntDigits10", mode2: 1, sanity: 6057706836)
(time: 1.5729450000000007, alg: "addIntDigits10", mode2: 2, sanity: 6823134569)
(time: 1.3679059999999978, alg: "addIntDigits10", mode2: 3, sanity: 5913000000)

addInt3OpenArray
(time: 0.9512420000000006, alg: "addInt3OpenArray", mode2: 1, sanity: 6057706836)
(time: 1.263928, alg: "addInt3OpenArray", mode2: 2, sanity: 6823134569)
(time: 0.887941000000005, alg: "addInt3OpenArray", mode2: 3, sanity: 5913000000)

addIntDigits10OpenArray
(time: 0.8212880000000027, alg: "addIntDigits10OpenArray", mode2: 1, sanity: 6057706836)
(time: 0.8867639999999994, alg: "addIntDigits10OpenArray", mode2: 2, sanity: 6823134569)
(time: 0.5291950000000014, alg: "addIntDigits10OpenArray", mode2: 3, sanity: 5913000000)
]#

const
  digits100: array[200, char] = ['0', '0', '0', '1', '0', '2', '0', '3', '0', '4', '0', '5',
    '0', '6', '0', '7', '0', '8', '0', '9', '1', '0', '1', '1', '1', '2', '1', '3', '1', '4',
    '1', '5', '1', '6', '1', '7', '1', '8', '1', '9', '2', '0', '2', '1', '2', '2', '2', '3',
    '2', '4', '2', '5', '2', '6', '2', '7', '2', '8', '2', '9', '3', '0', '3', '1', '3', '2',
    '3', '3', '3', '4', '3', '5', '3', '6', '3', '7', '3', '8', '3', '9', '4', '0', '4', '1',
    '4', '2', '4', '3', '4', '4', '4', '5', '4', '6', '4', '7', '4', '8', '4', '9', '5', '0',
    '5', '1', '5', '2', '5', '3', '5', '4', '5', '5', '5', '6', '5', '7', '5', '8', '5', '9',
    '6', '0', '6', '1', '6', '2', '6', '3', '6', '4', '6', '5', '6', '6', '6', '7', '6', '8',
    '6', '9', '7', '0', '7', '1', '7', '2', '7', '3', '7', '4', '7', '5', '7', '6', '7', '7',
    '7', '8', '7', '9', '8', '0', '8', '1', '8', '2', '8', '3', '8', '4', '8', '5', '8', '6',
    '8', '7', '8', '8', '8', '9', '9', '0', '9', '1', '9', '2', '9', '3', '9', '4', '9', '5',
    '9', '6', '9', '7', '9', '8', '9', '9']

proc firstPow10(n: int): uint64 {.compileTime.} =
  result = 1
  for i in 1..<n: result *= 10

func digits10*(x: uint64): int {.inline.} =
  ## Returns number of digits of `$x`
  if x >= firstPow10(11): # 1..10, 11..20
    if x >= firstPow10(16): # 11..15, 16..20
      if x >= firstPow10(18): # 16..17, 18..20
        if x >= firstPow10(19): # 18, 19..20
          if x >= firstPow10(20): result = 20 # 19, 20
          else: result = 19
        else: result = 18
      elif x >= firstPow10(17): result = 17 # 16, 17
      else: result = 16
    elif x >= firstPow10(13): # 11..12, 13..15
      if x >= firstPow10(14): # 13, 14..15
        if x >= firstPow10(15): result = 15 # 14, 15
        else: result = 14
      else: result = 13
    elif x >= firstPow10(12): result = 12 # 11, 12
    else: result = 11
  elif x >= firstPow10(6): # 1..5, 6..10
    if x >= firstPow10(8): # 6..7, 8..10
      if x >= firstPow10(9): # 8, 9..10
        if x >= firstPow10(10): result = 10 # 9, 10
        else: result = 9
      else: result = 8
    elif x >= firstPow10(7): result = 7 # 6, 7
    else: result = 6
  elif x >= firstPow10(3): # 1..2, 3..5
    if x >= firstPow10(4): # 3, 4..5
      if x >= firstPow10(5): result = 5 # 4, 5
      else: result = 4
    else: result = 3
  elif x >= firstPow10(2): result = 2 # 1, 2
  else: result = 1

proc addInt0(target: var string, x: uint64) =
  target.add $x

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

proc addInt3*(result: var string, origin: uint64) =
  var tmp: array[24, char]
  var num = origin
  var next = tmp.len - 1
  const nbatch = 100

  while num >= nbatch:
    let originNum = num
    num = num div nbatch
    let index = (originNum - num * nbatch) shl 1
    tmp[next] = digits100[index + 1]
    tmp[next - 1] = digits100[index]
    dec(next, 2)

  # process last 1-2 digits
  if num < 10:
    tmp[next] = chr(ord('0') + num)
  else:
    let index = num * 2
    tmp[next] = digits100[index + 1]
    tmp[next - 1] = digits100[index]
    dec next
  let n = result.len
  let length = tmp.len - next
  result.setLen n + length
  copyMem result[n].addr, tmp[next].addr, length

proc addInt3OpenArray*(ret: var openArray[char], origin: uint64): int {.inline.} =
  var tmp {.noInit.}: array[24, char]
  var num = origin
  var next = tmp.len - 1
  const nbatch = 100
  while num >= nbatch:
    let originNum = num
    num = num div nbatch
    let index = (originNum - num * nbatch) shl 1
    tmp[next - 1] = digits100[index]
    tmp[next] = digits100[index + 1]
    dec(next, 2)

  # process last 1-2 digits
  if num < 10:
    tmp[next] = chr(ord('0') + num)
  else:
    let index = num * 2
    tmp[next - 1] = digits100[index]
    tmp[next] = digits100[index + 1]
    dec next
  result = tmp.len - next
  copyMem ret[0].addr, tmp[next].addr, result

const nimHasAnLib = defined(nimHasAnLib)
when nimHasAnLib:
  {.compile: "/Users/timothee/git_clone//temp/acf/src/an_itoa.c".}
  proc an_ltoa(buf: ptr char, x: uint64): ptr char {.importc.}
  proc addIntAnlib(ret: var openArray[char]; num: uint64): int {.inline.} =
    let pr = an_ltoa(ret[0].addr, num)
    result = cast[int](pr) - cast[int](ret[0].addr)

template addIntImpl(ret; num: uint64, length: int) =
  var i = length - 2
  var x = num
  while i >= 0:
    let xi = (x mod 100) shl 1
    x = x div 100
    copyMem ret[i].addr, digits100[xi].unsafeAddr, 2
    i = i - 2
  if i == - 1: ret[0] = chr(ord('0') + x)

proc addIntDigits10OpenArray(ret: var openArray[char]; num: uint64): int {.inline.} =
  result = digits10(num)
  addIntImpl(ret, num, result)

proc addIntDigits10(result: var string, num: uint64) {.inline.} =
  let length = digits10(num)
  let n = result.len
  result.setLen n + length
  let ret = cast[ptr UncheckedArray[char]](result[n].addr)
  addIntImpl(ret, num, length)

import std/times

var c0 = 0

template mainAux2(algo; mode: static int, needResize: static bool = true) =
  when needResize:
    var s = ""
  else:
    var s: array[100, char]

  let t = cpuTime()
  let n = 10000_0000
  var c = 0
  const M = (1 shl 32) - 1
  # const M = (1 shl 50) - 1
  var x = 7'u64
  var j = 1
  for i in 0..<n:
    when mode == 1:
      # pseudo-random in 0..M
      x = (5 * x) and M
    elif mode == 2:
      # pseudo-random variant 2
      var x = cast[uint64](i)
      x = x + (x*x shl 5)
    elif mode == 3:
      # pseudo-random with small number bias v2
      x = (5 * x + cast[uint64](j)) and (1'u64 shl j) - 1
      j.inc
      if j > 50: j = 1
    else:
      static: doAssert false

    when needResize:
      s.setLen(0)
      algo(s, x)
      let m = s.len
    else:
      let m = algo(s, x)

    # prevent optimizing away
    # c += m + cast[int](s[(m shr 1) and 15]) # also possible
    c += m + cast[int](s[0])

    when false:
      if i < 70:
        # echo (s, c and 15, c, s2)
        echo (s[0..<m], c)

  let t2 = cpuTime()
  echo (time: t2 - t, alg: astToStr(algo), mode2: mode, sanity: c)
  if c0 == 0:
    c0 = c
  else:
    discard
    # doAssert c == c0

when true:
  import std/sugar
  for a in [0'u64, 1, 9, 10, 11, 99, 100, 101, 1234567, 12345670]:
    let expected = $a
    template chk2(algo) =
      doAssert "".dup(algo(a)) == expected
    chk2 addInt0
    chk2 addInt1
    chk2 addInt3
    chk2 addIntDigits10

    template chk(algo) =
      var s = newString(20)
      let n = algo(s, a)
      s.setLen n
      doAssert s == expected, $(s, expected)
    chk addIntDigits10OpenArray
    chk addInt3OpenArray
    when nimHasAnLib:
      chk addIntAnlib

template mainAux(algo; needResize: static bool = true) =
  block: # D20210625T100404
    echo astToStr(algo)
    mainAux2(algo, 1, needResize)
    mainAux2(algo, 2, needResize)
    mainAux2(algo, 3, needResize)

proc main =
  for i in 0..<3: # adjust as needed
    echo i
    mainAux(addInt0)
    mainAux(addInt1)
    mainAux(addInt3)
    mainAux(addIntDigits10)
    mainAux(addInt3OpenArray, needResize = false)
    mainAux(addIntDigits10OpenArray, needResize = false)
    when nimHasAnLib:
      mainAux(addIntAnlib, needResize = false)
main()
