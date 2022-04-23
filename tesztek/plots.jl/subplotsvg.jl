include("mymodule.jl")
using .mymodule

import Pkg
Pkg.precompile()


np=8
t=sample(-20:20,2*np,replace=false)
f=t[np+1:end]
t=t[1:np]

dt=Int(ceil(maximum(abs.(t))*0.5))
df=Int(ceil(maximum(abs.(f))*0.5))

T=[t,t.-dt, t.+dt, t]
F=[f,f.+df, -f.-df, -f]
perm=sample([1,2,3,4], 4, replace=false)
titles="ABCD"[perm] |> collect .|> string

# points + regression lines
pl=Array{Any}(undef, 4)
for k in sample(1:4, 4, replace=false)
  lx,hx = extrema(T[k])
  dx = ceil((hx-lx)*0.1)
  lx, hx = lx-dx, hx+dx

  ly,hy = extrema(F[k])
  dy = ceil((hy-ly)*0.1)
  ly, hy = ly-dy, hy+dy

  A = [ones(np,1) T[k]]
  A, b = A'*A, A'*F[k]
  x0, x1 = A\b

  p = plot(T[k], F[k], seriestype = :scatter, label = nothing)
  p = plot!([lx, hx], [x0+x1*lx, x0+x1*hx], label = nothing)

  p = plot!(xlims=(lx, hx), ylims=(ly, hy), title=titles[k])
  pl[k] = p
end
plot(pl..., layout = 4)
savefig("/tmp/pic.svg")

