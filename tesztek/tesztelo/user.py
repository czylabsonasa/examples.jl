from time import time
from sys import argv

def solve(I):
  sol = 0
  for i in range(I):
    for j in range(I):
      sol += i^j
  return sol

def solveall(a,b):
  for i in range(a,b+1):
    I=2**i
    t=time()
    ret=solve(I)
    t=time()-t
    print("{} {} {}".format(i,ret,t))


a,b=map(int,argv[1:])
solveall(a,b)