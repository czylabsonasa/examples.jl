using LaTeXStrings
using Statistics
using Plots

f(x,a,b)=x^2-2a*x+a^2+b^2
df(x,a,b)=2*x-2a


#c(x,a,b)=pi*b*(1+((x-a)/b)^2)
cr(x,a,b)=pi*(1+((x-a)/b)^2)
n(x,a,b)=exp(-0.5*((x-a)/b)^2)/sqrt(2*pi)

F(x,a,b)=cr(x,a,b)*n(x,a,b)



function simdriv(N,FF,ff,dff,AB)
  L=length(AB)
  res=fill(0.0,L)

  for l in 1:L
    (a,b)=AB[l]
    nit(x)=x-ff(x,a,b)/dff(x,a,b)
    F(x)=FF(x,a,b)
    x=rand()
    s=F(x)
    for k in 2:N
      x=nit(x)
      s+=F(x)
    end
    res[l]=s/N
  end 
  res
end



a=4
arr=collect(0.1:0.1:10)
res=simdriv(1000000,F,f,df,collect(zip(fill(a,length(arr)),arr)))
mtit=raw"{length=10^{6}},\ {poly=x^2-2ax+a^2+b^2},\ {a=4}\n  f={Norm\({x-a}/{b}\)}/{Cauchy\({x-a}/{b}\)}"
plot(arr,res,
  label=false,
  title=mtit,
  xlabel="b",ylabel="mean"
)

(mean(res), std(res)) |> println
savefig("pr.png")
