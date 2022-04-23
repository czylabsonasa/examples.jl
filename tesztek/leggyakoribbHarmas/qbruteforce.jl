include("defek.jl")

#meretek=[(100,100),(100,200),(200,100),(200,200)]
meretek=[(600,600)]
fl=open("qbruteforce.log","a")

for (nC,nD) in meretek
  fn="C$(nC)_D$(nD).txt"
  fin=open(fn,"r")
  tt=time()
  nC,D=mread(fn)
  tt=round(time()-tt,digits=3)
  println(fl,"read:$(fn):$(tt)s")

  tt=time()
  frek1,frek2=mfrek(nC,D)
  frek3=mqbruteforce(nC,D,frek1,frek2,0.9,0.5)
  mx=frek3 |> values |> maximum
  tt=round(time()-tt,digits=3)
  println(fl,"frek+qbruteforce:$(fn):$(mx):$(tt)s")
end

close(fl)
