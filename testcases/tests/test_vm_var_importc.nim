#[
VM importc var D20191207T175525

ADAPTED: D20191211T004219
addresses: D20191207T175525 at CT prints address instead of value: 140735821540136
[VM: allow importc var, cast[int](ptr type), correctly handle importc procs returning ptr types by timotheecour · Pull Request #12877 · nim-lang/Nim : VM: allow importc var, cast[int](ptr type), correctly handle importc procs returning ptr types by timotheecour · Pull Request #12877 · nim-lang/Nim](https://github.com/nim-lang/Nim/pull/12877)

## setup
build nim with -d:nimHasLibFFI
nim cpp --passC:-std=c++11 -d:timn_D20191207T181719 --app:lib -o:/tmp/libD20191211T004436.dylib $vitanim_D/testcases/tests/test_vm_var_importc_imp.nim
nim cpp -r --experimental:compiletimeFFI $vitanim_D/testcases/tests/test_vm_var_importc.nim
]#

import timn/echo0b

import system/ansi_c
import ./test_vm_var_importc_imp

proc fopen(filename, mode: cstring): pointer {.importc: "fopen", nodecl.}

template my_opt(foo, bar) =
  foo = foo + bar

proc my_opt2(foo: var float32, bar: float32) =
  foo = foo + bar

proc test_stderr()=
  var status = c_fprintf(getStderr(), "hello world stderr getStderr()\n")
  doAssert status > 0

  block:
    let a1 = cast[int](getStderr())
    let temp = getStderr()
    let a2 = cast[int](temp)
    doAssert a1 == a2
    doAssert a1 > 0
    echo0b ("getStderr()", a1)

  echo0b myc_float32
  let u = myc_float32
  echo0b (u, myc_float32, myc_float32, u + 1.2, myc_float32 + 12.3, $type(myc_float32))
  myc_float32 = -1.0
  doAssert myc_float32 == -1.0

  let z = mystderr2
  doAssert type(z) is CFilePtr
  let z2 = cast[int](z)
  echo0b z2
  echo0b ("mystderr2", cast[int](mystderr2), )
  status = c_fprintf(mystderr2, "hello world stderr mystderr2\n")
  doAssert status > 0
  status = c_fprintf(cstderr2, "hello world stderr cstderr2\n")
  doAssert status > 0


import std/macros
proc funMacroAux(a: NimNode) =
  echo0b (a.kind, a is ptr, a is ref, getType(a).kind)
  let pa = cast[int](a)
  echo0b pa
  when false:
    # Error: VM does not support 'cast' from tyInt to tyRef
    let a2 = cast[NimNode](pa)
    echo0b a2
    doAssert a == a2

macro funMacro(a: float) =
  funMacroAux(a)

proc test_NimNode()=
  let x = 1.2
  funMacro(x)

var g0 {.compiletime.} = 1.5
var g1 = 1.5

proc test_global_aux[T, T2](pb: T, b: T2) =
  let v = cast[int](pb)
  let pb2 = cast[ptr int](v)
  var pb3: type(pb2)
  doAssert v == cast[int](pb2)
  doAssert type(pb) is ptr float
  doAssert type(pb2) is ptr int
  doAssert pb2 == pb
  doAssert pb3 == nil
  doAssert pb2 != nil
  doAssert pb[] == b
  doAssert b == 1.5

proc test_global() =
  when nimvm:
    test_global_aux(addr(g0), g0)
  else:
    test_global_aux(addr(g1), g1)

proc main() =
  echo0b "in main"
  init_mystderr()

  test_stderr()

  test_NimNode()
  test_global()

  let mya = get_mya()
  block:
    let a1 = get_pointer()
    let a2 = get_pointer()
    doAssert a1 == a2
    block:
      proc foo[T](a: T) =
        doAssert(a == a1)
      foo(a2)
        # type PointerAux = distinct pointer
        # let a1b = PointerAux(a1)
        # let a2b = PointerAux(a2)
        # # when nimvm: # nim BUG: Error: illegal context for 'nimvm' magic
        # doAssert a1b == a2b

    doAssert mya == mya2
    doAssert cast[int](a1) == cast[int](a2)
    doAssert cast[int](mya) == cast[int](mya2)
    echo0b cast[int](mya)
    let a3 = cast[pointer](cast[int](a1))
    doAssert a3 == a1
    let a4 = cast[pointer](mya)
    doAssert a4 != a1

  block:
    let a4 = cast[pointer](mya)
    type Foo = type(mya)
    let a5 = cast[type(mya)](a4)
    doAssert a5 == mya
    doAssert a5 == cast[Foo](a4)
    doAssert get_x2(a5) == 2.0
    get_x2(a5) = 1.5
    doAssert get_x2(a5) == 1.5
    get_x2(a5) = 2.0

  block:
    let z1 = get_x2_impl(mya)
    let temp1 = z1[]
    let temp2 = get_x2_impl(mya)[]
    let temp3 = get_x2(mya)
    doAssert temp2 == temp3
    doAssert temp1 == temp3
    doAssert temp1 == 2.0

  # echo0b mya.x # Error: opcLdDeref unsupported ptr type: ("A", tyObject)

  block:
    let temp3 = get_x2_impl(mya)
    doAssert type(temp3) is ptr float32
    echo0b temp3[]
    echo0b get_x2(mya)

  doAssert mya.get_x2 == 2.0

  get_x2(mya) = 1.0
  doAssert mya.get_x2 == 1.0 # fails

  block:
    let temp1 = get_x2_impl(mya)
    temp1[] = 1.0
    doAssert mya.get_x2 == 1.0, $mya.get_x2
    temp1[] += 1.0
    doAssert mya.get_x2 == 2.0

  block:
    doAssert myb_float32_var == 1.0
    myb_float32_var = 2.0
    doAssert myb_float32_var == 2.0
    myb_float32_var += 1.5
    doAssert myb_float32_var == 3.5

    my_opt(myb_float32_var, 1.5)
    doAssert myb_float32_var == 3.5 + 1.5
    my_opt2(myb_float32_var, 1.5)
    doAssert myb_float32_var == 3.5 + 1.5 + 1.5
    myb_float32_var = 0
    myb_float32_var = myb_float32_var + 1.5
    doAssert myb_float32_var == 1.5
    myb_float32_var = 1.0

  doAssert myb_float32 == 1.0
  myb_float32 = 1.25
  doAssert myb_float32 == 1.25
  myb_float32 += 1.25 # D20191210T184152:here
  doAssert myb_float32 == 2.5

  template fun(e)=
    e = 123
    doAssert e == 123
    e = 0
    doAssert e == 0
    get_errno_wrap = 0
    doAssert get_errno_wrap() == 0
    let a = fopen("nonexistant", "r")
    doAssert get_errno_wrap() != 0
    doAssert get_errno_wrap() == get_errno()
    # doAssert myerrno3 == get_errno()
    doAssert e == get_errno()
    get_errno_wrap = 123
    doAssert get_errno_wrap() == 123
    doAssert get_errno() == 123

  fun(myerrno2)

  myerrno2 = 0
  myerrno2 += 2
  doAssert myerrno2 == 2

  when nimvm:
    discard
  else:
    doAssert mya.x == 12

static: main()
main()

