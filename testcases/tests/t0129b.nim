#[
D20190717T113730

nim c -r -d:danger -d:case1 -d:case_with_bytewiseHashing $vitanim_D/testcases/tests/t0129b.nim

-f may be needed unless nim >= https://github.com/nim-lang/Nim/issues/11758

other flags to compare different hashing:
-d:case_with_bytewiseHashing
-d:case_with_murmur
-d:case_default

## conclusions:
* default nim is, depending on `n`, 1000x slower compared to after PR that fixes #11758
* default nim is, even after PR that fixes #11758, still slower (in the 3rd case) with `type Elem = uint64` compared to both -d:case_with_bytewiseHashing and -d:case_with_murmur:

time 2.229572  (after PR)
vs
time 0.424859 with bytewiseHashing or murmur (after PR)
]#

import std/[hashes,oids,tables,strutils, times]
import std/[sets]
import std/math
import ../../murmur/murmur
import pkg/sysrandom

## bad behavior with current nim <= 44d80dd86373b9ba41051428948eae30ed97acd3

## adjust these as needed
# type Elem = int64
type Elem = uint64
# type Elem = float
# type Elem = pointer
# type Elem = float32
# type Elem = float32
# type Elem = int32

## good
# type Elem = uint16
# type Elem = int16
# type Elem = int8
# type Elem = int32

proc toElem[T](a: T): Elem =
  when compiles(Elem(a)): Elem(a)
  else: cast[Elem](a) # eg, pointer

when defined(case_with_murmur):
  proc hash*(x: string): Hash {.inline.} = toHashMurmur3(x.string)[0].Hash

# when defined(case_with_hash_string):
#   proc hash*(x: Elem): Hash {.inline.} =
#     hash($x)

when defined(case_with_bytewiseHashing):
  proc hash*(x: string): Hash {.inline.} = bytewiseHashing(result, x, 0, high(x))
  proc hash*(x: Elem): Hash {.inline.} =
    let x = $x
    bytewiseHashing(result, x, 0, high(x))

when defined(case_default):
  discard

when defined case1:
  # slow_set.nim
  var hs1: HashSet[Elem]
  var hs2: HashSet[Elem]
  var hs3: HashSet[Elem]

  when false:
    ## for older nim
    hs1.init
    hs2.init
    hs3.init

  let n = 100_000 * 10
  # let n = 100_000 * 100
  # let n = 100_000 * 20
  # let n = 100_000
  # let n = 100_000

  let m = n*10

  # 1st case: insert 0..200k
  var time = cpuTime()
  for i in 0..(2*n):
      let k1 = toElem(i)
      hs1.incl(k1)
  echo "time ", (cpuTime() - time)

  # 2nd case: interleave insert 0..100k and 100k..200k
  time = cpuTime()
  for i in 0..n:
      let k1 = toElem(i)
      let k2 = toElem(i + n)
      hs2.incl(k1)
      hs2.incl(k2)
  echo "time ", (cpuTime() - time)

  # 3rd case: interleave insert 0..100k and 1.0M..1.1M
  time = cpuTime()
  for i in 0..n:
      let k1 = toElem(i)
      let k2 = toElem(i + m)
      hs3.incl(k1)
      hs3.incl(k2)
  echo "time ", (cpuTime() - time)

