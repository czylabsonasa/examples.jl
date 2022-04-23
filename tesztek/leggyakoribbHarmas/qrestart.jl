include("defek.jl")

#meretek=[(100,100),(100,200),(200,100),(200,200)]
meretek=[(400,400)]
fl=open("qrestart.log","a")

for (nC,nD) in meretek
  fn="C$(nC)_D$(nD).txt"
  fin=open(fn,"r")
  tt=time()
  C,D=mread(fn)
  tt=round(time()-tt,digits=3)
  println(fl,"read:$(fn):$(tt)s")

  tt=time()
  frek1,frek2=mfrek(C,D)
  frek3=mqbruteforce(C,D,frek1,frek2,0.9,0.5)
  qmx=frek3 |> values |> maximum
  qfrek3=mrestart(D,frek1,frek2,qmx)
  mx3=
  if length(qfrek3)>0
    qfrek3 |> values |> maximum
  else
    "NA"
  end
  tt=round(time()-tt,digits=3)
  println(fl,"frek+qbruteforce+restart:$(fn):$(qmx),$(mx3):$(tt)s")
end

close(fl)

