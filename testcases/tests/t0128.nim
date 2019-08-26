#[
SEE D20190624T151230
]#

import std/[hashes,oids,tables,strutils]
import std/math
import ../../murmur/murmur

const num2 = pow(2.float, 20).int - 1

proc computeEntropy[T](t: CountTable[T]): float =
  var total = 0
  var max = 0
  for k,v in t:
    total += v
    if v > max: max = v

  for k,v in t:
    let x = v / total
    assert x > 0
    result -= x * log2(x)

  # entropy of ideal, uniform distribution:
  var y: float = 0
  for k,v in t:
    let x = 1 / t.len
    y -= x * log2(x)
  echo (y, total, total / t.len, max)

proc fun() =
  var dummy: Hash
  var t = CountTable[Hash]()
  proc toHashMurmur3_2(a: string): Hash = toHashMurmur3(a)[0].Hash

  template run(fun: typed) =
    let n = 1_000_000
    t.reset
    for i in 0..<n:

      let s = $genOid()

      when false:
        ## bad cases
        let s = align($i, 8)
        let s = align($i, 9)
        let s = align($i, 10)
        let s = align($i, 11)
        let s = align($i, 16)
        let s = align($i, 17)
        let s = align($i, 18)
        let s = align($i, 19)
        let s = $genOid()

      when false:
        ## good cases
        let s = align($i, 0)
        let s = align($i, 1)
        let s = align($i, 2)
        let s = align($i, 3)
        let s = align($i, 4)
        let s = align($i, 5)
        let s = align($i, 6)
        let s = align($i, 7)
        let s = align($i, 12)
        let s = align($i, 13)
        let s = align($i, 14)
        let s = align($i, 15)
        let s = align($i, 20)

      let h = fun(s)
      let h2 = h and num2
      dummy += h2
      t.inc h2

      if i < 4:
        echo (i, s, h, h2)

    var count = 0
    for k,v in t:
      count.inc
      if count < 4:
        echo k, " ", v
    echo (entropy: computeEntropy(t))

  run toHashMurmur3_2
  run hash

  echo dummy

proc main()=
  fun()

main()
