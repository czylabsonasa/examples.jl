function mkfun()
  noc=0
  getnoc()=noc
  function fun(a,b)
    noc+=1
    a+b
  end
  fun,getnoc
end


f,fnoc=mkfun()
g,gnoc=mkfun()
h(a,b)=0
funarr=[f,g,h,f]
for k in 1:1000
  funarr[rand(1:length(funarr))](rand(1:10),rand(1:10))
end
println("f: ",fnoc())
println("g: ",gnoc())
