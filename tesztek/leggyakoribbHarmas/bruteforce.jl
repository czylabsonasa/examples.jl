include("defek.jl")

#meretek=[(100,100),(100,200),(200,100),(200,200)]
meretek=[(600,600)]
fl=open("bruteforce.log","a")

for (nC,nD) in meretek
  fn="C$(nC)_D$(nD).txt"
  fin=open(fn,"r")
  tt=time()
  C,D=mread(fn)
  tt=round(time()-tt,digits=3)
  println(fl,"read:$(fn):$(tt)s")

  tt=time()
  frek3=mbruteforce(D)
  mx=frek3 |> values |> maximum
  tt=round(time()-tt,digits=3)
  println(fl,"bruteforce:$(fn):$(mx):$(tt)s")
end

close(fl)

