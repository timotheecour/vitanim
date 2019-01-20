import os
import shutil

print("python start1")

def runCmd(cmd):
  print(("runCmd",cmd))
  import subprocess
  # subprocess.check_call(cmd, shell=True) # BUG: this doesn't print anything in azure!
  output = subprocess.check_output(cmd, shell=True)
  output=output.decode('utf8')
  print("output:")
  print(output)
  # subprocess.check_call(cmd, shell=True, stdout=subprocess.STDOUT)

def buildNimCsources():
  print("in buildNimCsources")
  runCmd("git clone --depth 1 https://github.com/nim-lang/csources.git")
  # runCmd("cd csources && sh build.sh")

buildNimCsources()
print("after buildNimCsources")
