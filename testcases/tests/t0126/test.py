"""
TOOD: convert to nimpy or something :)

CAVEEAT: quick and dirty code below
"""
# import matplotlib
import matplotlib.pyplot as plt

def run():
  file = "/tmp/D20190124T204416/log.txt"
  with open(file) as f:
    read_data = f.read()

  x=[]
  for a in read_data.splitlines():
    if not a.startswith('[GC] occupied memory:'):
      continue
    xi = int(a.split()[3])
    x.append(xi)
  print(x)


  # x = int(a.splitlines[3]) for a in read_data:
  #   # [GC] occupied memory: 90280
  #   # int(a.splitlines[3])
  # print(x)


  # plt.plot(x)

  # x=x[0:200] # truncate for visibility

  plt.plot(x, linestyle="",marker="o")
  plt.ylabel('[GC] occupied memory:')
  plt.show()

run()
