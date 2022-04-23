include("defek.jl")

# function cDist(nC)
#   wC=rand(1:20,nC)
#   wC=wC/sum(wC) |> Weights
# end

function cDist(nC)
  wC=sample(1:nC,nC,replace=false)
  wC=wC.^1.2 
  wC=wC/sum(wC) |> Weights
end


function dDist(nC,nD)
  A=max(15,0.2*nC)
  B=max(0.9*nC,A+5)
  dist=Uniform(A,B)
  # a dobozok meretei
  rand(dist,nD) .|> floor .|> Int
end

#meretek=[(100,100),(100,200),(200,100),(200,200)]
meretek=[(600,600)]


fl=open("gendata.log","w")
# generalas
for (nC,nD) in meretek
  tt=time()
  C,D=mgen(nC,cDist,nD,dDist)
  fn="C$(nC)_D$(nD).txt"
  tt=round(time()-tt,digits=3)
  println(fl,"gen:$(fn):$(tt)s")
  tt=time()
  mwrite(C,D,fn)
  tt=round(time()-tt,digits=3)
  println(fl,"write:$(fn):$(tt)s")
end
close(fl)
