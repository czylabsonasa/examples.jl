# x-(x^2+1)/(2x)
using Statistics
using Plots

N=1000000
res = let
  # f(x)=sin(x)+2
  # df(x)=cos(x)

  #f(x)=exp(x)+1.0
  #df(x)=exp(x)

  # f(x)=x^2+1
  # df(x)=2*x

  f(x)=x^2+x+1
  df(x)=2x+1

  
  nit(x)=x-f(x)/df(x)


  res=fill(0.0,N)
  res[1]=rand()
  for i in 2:N
    res[i]=nit(res[i-1])
  end
  res
end 

res=cumsum(res) ./ (1:N)

plot(1:N,res)

#(length(res[0 .< res .< 2]), mean(res), std(res)) |> println

