import std/[os,strformat,nre]

proc getNimGitHash*(): string =
  # MOVE
  const nim = getCurrentCompilerExe()
  const cmd = fmt"{nim} -v"
  const (output, exitCode) = gorgeEx(cmd)
  doAssert exitCode == 0
  return output.find(re"git hash: (\w+)").get.captures[0]

when isMainModule:
  echo getNimGitHash()
