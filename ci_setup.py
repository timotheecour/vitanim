import os
import shutil

print("python script v2")

def runCmd(cmd):
  print(("runCmd",cmd))
  import subprocess
  subprocess.check_call(cmd, shell=True) # BUG: this doesn't print anything in azure!
  # subprocess.check_call(cmd, shell=True, stdout=subprocess.STDOUT)
  if False:
    output = subprocess.check_output(cmd, shell=True)
    output=output.decode('utf8')
    print("output:")
    print(output)

def buildNimCsources():
  print("in buildNimCsources")
  runCmd("git clone --depth 1 https://github.com/nim-lang/csources.git")
  runCmd("cd csources && sh build.sh")

buildNimCsources()
print("after buildNimCsources")
