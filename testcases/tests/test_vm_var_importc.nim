#[
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

proc main()=
  echo0b "in main"
  init_mystderr()
  let mya = get_mya()
  when false:
    # BUG: fails
    doAssert mya == mya2
  doAssert cast[int](mya) == cast[int](mya2)
  echo0b ("cast[int](mya)", cast[int](mya))

  when true:
    #[
    BUG:D20191210T175437:here super weird, looks like mya gets modified inside the c lib if
      let mya = get_mya()
    is called after this block:
    ]#
    var status = c_fprintf(getStderr(), "hello world stderr getStderr()\n")
    doAssert status > 0

    when false:
      # BUG: need to do in 2 steps
      # Error: opcCastPtrToInt: regs[rb].kind: rkInt
      echo0b ("getStderr()", cast[int](getStderr()), )

    block:
      let temp = getStderr()
      echo0b cast[int](temp)

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

  # BUG: some C++ float don't match nim's float32 exactly, eg for `float myb_float32 = 3.1415`
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

