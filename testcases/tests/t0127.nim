#[
KEY llvm IR Halide
D20190201T004613

output (snippet):
```
define void @entryPoint() #0 {
  %1 = alloca %struct.TFrame_, align 8
  %2 = alloca i64, align 8
  %3 = alloca i64, align 8
  %4 = alloca [1 x %struct.NimStringDesc*], align 8
  %5 = alloca i64, align 8
  %6 = alloca i64, align 8
  %7 = getelementptr inbounds %struct.TFrame_, %struct.TFrame_* %1, i32 0, i32 1
...
```

]#

import strformat, macros, os

# IMPROVE
from "$nim/testament/lib/stdtest/specialpaths.nim" import stdlibDir

proc generateLLVMIR_file(file: string): string =
  let outFile = "/tmp/foo.ll"
  let cmd = &"clang -S -emit-llvm -o {outFile} -I {stdlibDir} {file}"
  echo cmd
  let (output, exitCode) = gorgeEx cmd
  doAssert exitCode == 0
  return outFile.readFile

proc generateLLVMIR_code(input: string): string =
  let file = "/tmp/foo.c"
  writeFile file, input
  generateLLVMIR_file(file)

proc DSLtoLLVMIRImpl(code: string): string =
  let outDir = "/tmp/d07"
  let fileSrc = outDir / "foo2.nim"
  fileSrc.writeFile code
  let fileOut = fileSrc.changeFileExt(".c")

  let cmd = &"nim c --noMain --compileOnly --nimcache:{outDir} -o:{fileOut} {fileSrc}"
  echo cmd
  let (output, exitCode) = gorgeEx(cmd)
  echo output
  doAssert exitCode == 0
  echo fileOut
  result = generateLLVMIR_file(fileOut)

macro DSLtoLLVMIR(body: untyped): untyped =
  #[
  # note: could have a preprocessing macro to interpret a DSL, eg:
  forEach x in a, y in b, z in c:
    z = x + y
  ]#
  let code = body.repr
  let ir = DSLtoLLVMIRImpl(code)
  result = quote do:
    echo `ir`

DSLtoLLVMIR:
  proc entryPoint() {.exportc.} =
    for i in 0..<10:
      echo i*i
