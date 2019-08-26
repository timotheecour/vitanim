#[
D20190624T193837 murmur
]#

import std/[hashes,oids,tables,strutils, times]
import std/math
import ../../murmur/murmur
import pkg/sysrandom

when defined(case_with_murmur):
  # proc hash*(x: string): Hash {.inline.} = toHashMurmur3(x, nBits=128)[0].Hash
  proc hash*(x: string): Hash {.inline.} = toHashMurmur3(x, nBits=64).Hash

when defined(case_with_hash_silly):
  proc hash*(x: string): Hash {.inline.} =
    result = toHashMurmur3("asdf")[0].Hash
    # echo result

when defined(case_with_bytewiseHashing):
  proc hash*(x: string): Hash {.inline.} = bytewiseHashing(result, x, 0, high(x))

# template run(keyFun: untyped, s: string) =
proc run[Fun](keyFun: Fun, s: string) =
  var t: Table[string, string]
  let n = 100_000
  var keys: seq[string]
  var keys0: seq[string]

  var tKey, tHash, tInsert, tGet: float
  var dummy = 0 # prevent optimizing out

  block:
    let t0 = epochTime()
    for i in 0..<n:
      let key = keyFun(i)
      keys0.add key
      dummy += key.len
    tKey += epochTime() - t0

  block:
    let t0 = epochTime()
    for i in 0..<n:
      let key = keys0[i]
      for j in 0..<100:
        let h = hash(key)
        dummy += h.int
    tHash += epochTime() - t0

  block:
    let t0 = epochTime()
    for i in 0..<n:
      let key = keyFun(i)
      t[key] = key
      keys.add key
    tInsert += epochTime() - t0

  block:
    let t0 = epochTime()
    for i in 0..<25: # repeat a few times because insertion is slower
      for key in keys:
        let val = t[key]
        dummy += val.len
        assert val == key # sanity check
    tGet += epochTime() - t0
  
  let s2 = alignLeft(s, 21)
  template fmt2(a): auto = formatFloat(a, ffDecimal, 4)
  echo (key: s2, tKey: tKey.fmt2, tHash: tHash.fmt2, tInsert: tInsert.fmt2, tGet: tGet.fmt2)
  doAssert dummy != 0

template genRand2(l: int): untyped =
  block:
    proc fun(i: int): string {.inline.} = getRandomString(l)
    fun

template genRandOid(): untyped =
  block:
    proc fun(i: int): string {.inline.} = $genOid()
    fun

template genRand(i: int, l: int): untyped = getRandomString(l)
template keyFun2(i: int): untyped = $genOid()

proc main() =
  # genOid: 24
  run(genRandOid(), "genRandOid")
  for m in (1, 2, 4, 8, 16, 32, 64, 100, 128, 256, 512, 1024, 2048).fields:
    run(genRand2(m), "getRandomString:" & $m)
main()
