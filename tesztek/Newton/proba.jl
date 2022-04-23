# x-(x^2+1)/(2x)
using Statistics
using Plots

# f(x)=sin(x)+2
# df(x)=cos(x)

#f(x)=exp(x)+1.0
#df(x)=exp(x)

# f(x)=x^2+1
# df(x)=2*x
f(x)=x^2+x+1
df(x)=2*x+1
# f(x)=x^2-20x+101
# df(x)=2*x-20



nit(x)=x-f(x)/df(x)

F(x)=sqrt(pi/2)*(1+x^2)*exp(-0.5*x^2)

# f(x)=x^2+x+1
# df(x)=2x+1


function sim(N,ISM,nit,F)
  res=fill(0.0,ISM)
  for i in 1:ISM
    x=rand()
    s=F(x)
    for k in 2:N
      x=nit(x)
      s+=F(x)
    end
    res[i]=s/N
  end
  res
end 

function sim1inst(N,nit,F)
  res=fill(0.0,N)

  x=rand()
  s=F(x)
  res[1]=s

  for k in 2:N
    x=nit(x)
    s+=F(x)
    res[k]=s
  end
  res ./ (1:N)
end 

res=sim1inst(1000000,nit,F)
plot(res,
  label=false,
  title="orbit length=$(N), instance=1",
  xlabel="k",ylabel="k-th average"
)
(mean(res), std(res)) |> println
savefig("mplot2b.png")


# N,ISM=1000000,100
# res=sim(N,ISM,nit,F)

# (mean(res), std(res)) |> println

# plot(res,
#   label=false,
#   title="orbit length=$(N), instances=$(ISM)",
#   xlabel="instance",ylabel="orbit average"
# )
# savefig("mplot.png")


# N,ISM=100000,1000
# res=sim(N,ISM,f,df)

# (mean(res), std(res)) |> println

# plot(res,
#   label=false,
#   title="orbit length=$(N), instances=$(ISM)",
#   xlabel="instance",ylabel="orbit average"
# )
# savefig("mplot3.png")

