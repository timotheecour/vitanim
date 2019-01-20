import os
import shutil

print("python script v2")

def runCmd(cmd):
  # D20190120T053813:here
  print(("runCmd",cmd))
  import subprocess
  subprocess.check_call(cmd, shell=True) # works (w unbuffer)
  if False:
    output = subprocess.check_output(cmd, shell=True)
    output=output.decode('utf8')
    print(output)

def buildNimCsources():
  print("in buildNimCsources")
  runCmd("git clone --depth 1 https://github.com/nim-lang/csources.git")
  runCmd("cd csources && sh build.sh")

buildNimCsources()
print("after buildNimCsources")
