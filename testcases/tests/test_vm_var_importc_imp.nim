when defined(timn_D20191207T181719):
  {.emit:"""
  #include <stdlib.h>
  #include <stdio.h>
  #include <errno.h>
  NIM_EXTERNC
  FILE* mystderr = (FILE*) 1234;
  NIM_EXTERNC
  FILE* mystderrb = 0;

  class A{ // FACTOR test_vm_var_importc_imp.h
   public:
    int x = 12;
    float x2 = 2.0;
    int x3 = 3;
  };

  NIM_EXTERNC
  A* new_A(){
    return new A();
  }

  A* mya = 0;
  float myb_float32 = 1.0;
  float myc_float32 = 5.0;

  NIM_EXTERNC
  void init_mystderr(){
    printf("in init_mystderr\n");
    mystderr = stderr;
    mystderrb = stderr;
    mya = new A();
    auto mya2 = mya;
    auto ret = (ptrdiff_t) mya;
  }

  NIM_EXTERNC
  A* get_mya(){
    return mya;
  }

  NIM_EXTERNC
  float* get_x2(A* a){
    return &a->x2;
  }

  NIM_EXTERNC
  float* get_myb_float32_impl(){ return &myb_float32; }

  NIM_EXTERNC
  int get_errno(){ return errno; }
  NIM_EXTERNC
  int* get_errno_ptr(){ return &errno; }

  NIM_EXTERNC
  FILE* getStderr(){ return stderr;}
  NIM_EXTERNC
  FILE* getStdout(){ return stdout;}
  """.}

else:
  from system/ansi_c import CFilePtr
  const libF* = "/tmp/libD20191211T004436.dylib"
  {.push importc, dynlib: libF.}
  proc getStderr*(): CFilePtr
  proc getStdout*(): CFilePtr
  proc init_mystderr*()
  var mystderr*: CFilePtr
  {.pop.}

  type TA* {.importcpp: "struct A", header: "test_vm_var_importc_imp.h".} = object # BUG: `header` should not be needed
  # type TA* {.importcpp: "struct A", incompleteStruct.} = object
  # type TA* {.importcpp: "struct A".} = object
    x*: cint
    x2*: float32
    x3*: cint

  type A* = ptr TA

  var mya2* {.importc: "mya", dynlib: libF.}: A

  proc get_mya*(): A {.importc, dynlib: libF.}

  var myc_float32* {.importc, dynlib: libF.}: float32

  var myb_float32_var* {.importc: "myb_float32", dynlib: libF.}: float32

  proc get_myb_float32_impl*(): ptr float32 {.importc: "get_myb_float32_impl", dynlib: libF.}
  template myb_float32*(): untyped =
    when false:
      # BUG: this doesn't work:
      let temp = get_myb_float32_impl()
      temp[]
    else:
      get_myb_float32_impl()[]

  proc get_x2_impl*(a: A): ptr float32 {.importc: "get_x2", dynlib: libF.}
  template get_x2*(a: A): untyped =
    get_x2_impl(a)[]

  ## stderr
  # __stderrp: see https://github.com/vxgmichel/aioconsole/pull/16/files
  const stderr_name = when defined(osx): "__stderrp" else: "stderr"
  var cstderr2* {.importc: stderr_name, header: "<stdio.h>".}: CFilePtr
  var mystderr2* {.importc: "mystderr", dynlib: libF.}: CFilePtr

  ## errno
  proc get_errno*(): cint {.importc: "get_errno", dynlib: libF.}
  proc get_errno_ptr*(): ptr cint {.importc: "get_errno_ptr", dynlib: libF.}
  template get_errno_wrap*(): untyped = get_errno_ptr()[]

  var myerrno2* {.importc: "errno", header: "<errno.h>".}: cint
