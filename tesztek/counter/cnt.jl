function myfun0()
  sleep(0.1*rand())
end

function myfun1(x)
  sleep(0.2*x)
end

function myfun2(x,y)
  sleep(x*y)
end

struct Cnt{F}
  f::F
  callsat::Array{Float64}
end

function (c::Cnt)(x...)
  push!(c.callsat,time())
  c.f(x...)
end


function caller(fun0,fun1,fun2,n)
  for k in 1:n
    r=rand()
    if r<1.0/3.0
      fun0()
    elseif r<2.0/3.0
      fun1(rand())
    else
      fun2(rand(),rand())
    end
  end
end  

cmyfun0=Cnt(myfun0,Float64[])
cmyfun1=Cnt(myfun1,Float64[])
cmyfun2=Cnt(myfun2,Float64[])

caller(cmyfun0,cmyfun1,cmyfun2,10)

[cmyfun0.callsat, cmyfun1.callsat, cmyfun2.callsat] .|> length |> println
