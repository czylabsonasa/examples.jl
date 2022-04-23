using StatsBase

N=10000
REP=100000


fr = FrequencyWeights(fill(1,N));

t=time()
for k in 1:REP
  fr[sample(1:N,fr)]+=1
end
println(time()-t)


w=fill(1,N)
t=time()
for k in 1:REP
  w[sample(1:N,Weights(w))]+=1
end
println(time()-t)


c=fill(0,N+REP)
c[1:N] .= 1:N
t=time()
for k in N+1:N+REP
  c[k]=sample(@view c[1:k-1])
end
println(time()-t)
