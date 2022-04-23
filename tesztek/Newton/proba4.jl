using LaTeXStrings
using Statistics
using Plots

iter1(x)=2*x/(1-x^2)
iter2(x)=0.5*(x-1/x)
iter3(x)=0.2*iter1(x)+0.8*iter2(x)
iter4(x)=x-(exp(pi*x)+1)/(pi*exp(pi*x))


function mkorbit(N,it,x)
  res=fill(0.0,N)
  res[1]=x
  for k in 2:N
    x=it(x)
    res[k]=x
  end
  res
end

A=1000
N=200000
h=mkorbit(N,iter4,rand()) |> cumsum
psum(a,b)=h[b]- if a>1 h[a-1] else 0 end
g=fill(0.0,N-A+1)
k=1
for b in A:N
  g[k]=psum(b-A+1,b)/A
  global k+=1
end

histogram(g,normalize=true)
a,b=extrema(g)
xx=a:0.1:b
f(x)=1/(pi*(1+x^2))
plot!(xx, f.(xx) )


# F(x)=sqrt(pi/2)*(1+x^2)*exp(-0.5*x^2)
# function sim(N,ISM,iter,F)
#   res=fill(0.0,ISM)
#   for i in 1:ISM
#     x=rand()
#     s=F(x)
#     for k in 2:N
#       x=iter(x)
#       s+=F(x)
#     end
#     res[i]=s/N
#   end
#   res
# end 


# N=10000
# ISM=100
# res=sim(N,ISM,iter4,F)
# plot(1:ISM,res)

# #c(x,a,b)=pi*b*(1+((x-a)/b)^2)
# cr(x,a,b)=pi*(1+((x-a)/b)^2)
# n(x,a,b)=exp(-0.5*((x-a)/b)^2)/sqrt(2*pi)

# F(x,a,b)=cr(x,a,b)*n(x,a,b)



# function simdriv(N,FF,ff,dff,AB)
#   L=length(AB)
#   res=fill(0.0,L)

#   for l in 1:L
#     (a,b)=AB[l]
#     nit(x)=x-ff(x,a,b)/dff(x,a,b)
#     F(x)=FF(x,a,b)
#     x=rand()
#     s=F(x)
#     for k in 2:N
#       x=nit(x)
#       s+=F(x)
#     end
#     res[l]=s/N
#   end 
#   res
# end



# a=4
# arr=collect(0.1:0.1:10)
# res=simdriv(1000000,F,f,df,collect(zip(fill(a,length(arr)),arr)))
# mtit=raw"{length=10^{6}},\ {poly=x^2-2ax+a^2+b^2},\ {a=4}\n  f={Norm\({x-a}/{b}\)}/{Cauchy\({x-a}/{b}\)}"
# plot(arr,res,
#   label=false,
#   title=mtit,
#   xlabel="b",ylabel="mean"
# )

# (mean(res), std(res)) |> println
# savefig("pr.png")
