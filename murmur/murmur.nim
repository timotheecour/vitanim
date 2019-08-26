#[
D20190624T151119
ADAPTED from https://github.com/PeterScott/murmur3/blob/master/murmur3.c which said:
MurmurHash3 was written by Austin Appleby, and is placed in the public domain
and ported to nim
]#

template `[]`*[T](p: ptr T, off: int): T =
  (p + off)[]
template `+`*[T](p: ptr T, off: int): ptr T =
  cast[ptr T](cast[ByteAddress](p) +% off * sizeof(T))

template `^=`(a, b) = a = a xor b

template rotl32(x: uint32, r: int8): uint32 =
  (x shl r) | (x shr (32 - r))

template ROTL64(x: uint64, r: int8): uint64 =
  (x shl r) or (x shr (64 - r))

#[
Block read - if your platform needs to do endian-swapping or can only handle aligned reads, do the conversion here
]#
template getblock(p, i): untyped = p[i]

proc fmix32(h: uint32): uint32 =
  # Finalization mix - force all bits of a hash block to avalanche
  var h = h
  h ^= h shr 16
  h *= 0x85ebca6b'u32
  h ^= h shr 13
  h *= 0xc2b2ae35'u32
  h ^= h shr 16
  return h

proc fmix64(k: uint64): uint64 {.inline.} =
  var k = k
  k ^= k shr 33
  k *= 0xff51afd7ed558ccd'u64
  k ^= k shr 33
  k *= 0xc4ceb9fe1a85ec53'u64
  k ^= k shr 33
  k

proc MurmurHash3_x64_128*(key: ptr uint8, len: int, seed: uint32 = 0, nBits: static int): auto =
  # let data: ptr uint8 = key[0].unsafeAddr
  # let data: ptr uint8 = cast[ptr uint8](key[0].unsafeAddr)
  let data: ptr uint8 = key
  let nblocks = len div 16
  var i=0
  var h1: uint64 = seed
  var h2: uint64 = seed
  const c1 = 0x87c37b91114253d5'u64
  const c2 = 0x4cf5ad432745937f'u64
  # body
  let blocks = cast[ptr uint64](data)
  for i in 0 ..< nblocks:
    var k1: uint64 = getblock(blocks, i*2+0)
    var k2: uint64 = getblock(blocks, i*2+1)
    k1 *= c1
    k1 = ROTL64(k1,31)
    k1 *= c2
    h1 ^= k1
    h1 = ROTL64(h1,27)
    h1 += h2
    h1 = h1*5+0x52dce729
    k2 *= c2
    k2  = ROTL64(k2,33)
    k2 *= c1
    h2 ^= k2
    h2 = ROTL64(h2,31)
    h2 += h1
    h2 = h2*5+0x38495ab5

  # tail
  let tail: ptr uint8 = (data + nblocks*16)
  var k1 = 0'u64
  var k2 = 0'u64
  var state = len and 15
  while state > 0:
    case state
    of 15: k2 ^= tail[14].uint shl 48
    of 14: k2 ^= tail[13].uint shl 40
    of 13: k2 ^= tail[12].uint shl 32
    of 12: k2 ^= tail[11].uint shl 24
    of 11: k2 ^= tail[10].uint shl 16
    of 10: k2 ^= tail[ 9].uint shl 8
    of 9:
      k2 ^= tail[ 8].uint shl 0
      k2 *= c2
      k2  = ROTL64(k2,33)
      k2 *= c1
      h2 ^= k2

    of 8: k1 ^= tail[ 7].uint shl 56
    of 7: k1 ^= tail[ 6].uint shl 48
    of 6: k1 ^= tail[ 5].uint shl 40
    of 5: k1 ^= tail[ 4].uint shl 32
    of 4: k1 ^= tail[ 3].uint shl 24
    of 3: k1 ^= tail[ 2].uint shl 16
    of 2: k1 ^= tail[ 1].uint shl 8
    of 1:
      k1 ^= tail[ 0].uint shl 0
      k1 *= c1
      k1  = ROTL64(k1,31)
      k1 *= c2
      h1 ^= k1
      break
    of 0: break
    else: assert false
    state.dec

  # finalization
  h1 ^= len.uint64
  h2 ^= len.uint64

  h1 += h2
  h2 += h1

  h1 = fmix64(h1)
  h2 = fmix64(h2)

  h1 += h2
  when nBits == 128:
    result = [h1, h1 + h2]
  elif nBits == 64:
    result = h1
  else:
    static: doAssert false, $nBits

const nBitsDefault = 64

proc toHashMurmur3*(x: pointer, len: int, seed = 0'u32, nBits: static int = nBitsDefault): auto =
  MurmurHash3_x64_128(cast[ptr uint8](x), len, seed, nBits=nBits)

proc toHashMurmur3*(x: string, seed = 0'u32, nBits: static int = nBitsDefault): auto =
  MurmurHash3_x64_128(cast[ptr uint8](x[0].unsafeAddr), x.len, seed, nBits=nBits)
  # MurmurHash3_x64_128(x.toOpenArray(0, high(x)), seed)
  # MurmurHash3_x64_128(x[0].unsafeAddr, x.len, seed)

when isMainModule:
  import std/strutils

  {.compile: "/Users/timothee/git_clone/murmur3/murmur3.c" .} # PATH
  # {.compile: "/Users/timothee/git_clone/nim/timn/src/timn/murmur3.c" .}
  proc c_MurmurHash3_x64_128(key: pointer, len: cint, seed: uint32, pout: ptr array[2, uint64]) {.importc: "MurmurHash3_x64_128".}

  proc fun() =
    let seed = 0'u32
    let prefix = "hellow ljasdf lksajdfpiwjepijfaspdf 1"
    var x = prefix & "a"
    let h1 = toHashMurmur3(x)
    echo h1

    when nimvm: discard
    else:
      var pout: array[2, uint64]
      echo "c version:"
      c_MurmurHash3_x64_128(x[0].addr, x.len.cint, seed, pout.addr)
      doAssert pout == h1
      echo pout

    block:
      var x2 = prefix & "b"
      var x3 = prefix & "c"
      let h2 = toHashMurmur3(x2)
      let h3 = toHashMurmur3(x3)
      echo toBin(cast[BiggestInt](h1[1]), 64)
      echo toBin(cast[BiggestInt](h2[1]), 64)
      echo toBin(cast[BiggestInt](h3[1]), 64)

  proc main() =
    # static: fun() # TODO: use VM callback to allow its use in VM?
    fun()

  main()
