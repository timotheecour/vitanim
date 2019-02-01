#[
KEY llvm IR

UNTESTED
]#

proc generateLLVMIR(input: sring): string =
  let file = "/tmp/foo.c"
  let outFile = "/tmp/foo.ll"
  writeFile file, input
  let (output, exitCode) = gorgeEx(&"clang -S -emit-llvm -o {outFile} {file}")
  doAssert exitCode == 0
  return outFile.readFile

static: generateLLVMIR: """
  void main(){}
"""
