using StatsBase

let
  MAX=100000
  REP=10000


  c=fill(0,MAX)

  c[1:3]=1:3
  C=3

  start=4
  t=time()
  for k in start:MAX
    if rand()<0.1
      C+=1
      c[k]=C
    else
      c[k]=sample(@view c[1:k-1])
    end
  end
  println(time()-t)

  fr=fill(0,C)
  for k in 1:MAX
    fr[c[k]]+=1
  end

  mf=maximum(fr)
  println(mf)
  dist=fill(0.0,mf)
  for v in fr
    dist[v]+=1
  end
  dist = dist ./ sum(fr)
  dist=dist[dist .> 1e-5]
  dist=log.(dist)

end