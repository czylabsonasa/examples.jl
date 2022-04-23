using RuntimeGeneratedFunctions
RuntimeGeneratedFunctions.init(@__MODULE__)

let

  ex1 = :((x, y, z) -> sum(x)- prod(y) + z)
  f1 = @RuntimeGeneratedFunction(ex1)


  pool=rand(10000000)

  @time begin
    v1=0
    i=1
    for it in 1:100000
      x=view(pool,i:i+4-1); i+=4
      y=view(pool,i:i+2-1); i+=2
      z=pool[i]; i+=1
      v1+=f1(x,y,z)
    end
    println("RGF\n\t",v1)
  end

  f2(x,y,z) = (sum(x)- prod(y) + z)
  @time begin
    v2=0
    i=1
    for it in 1:100000
      x=view(pool,i:i+4-1); i+=4
      y=view(pool,i:i+2-1); i+=2
      z=pool[i]; i+=1
      v2+=f2(x,y,z)
    end
    println("f()\n\t",v2)
  end

  f3=(x,y,z) -> (sum(x)- prod(y) + z)
  @time begin
    v3=0
    i=1
    for it in 1:100000
      x=view(pool,i:i+4-1); i+=4
      y=view(pool,i:i+2-1); i+=2
      z=pool[i]; i+=1
      v3+=f3(x,y,z)
    end
    println("()->\n\t",v3)
  end

  function f4(x,y,z)
    (sum(x)- prod(y) + z)
  end

  @time begin
    v4=0
    i=1
    @inbounds for it in 1:100000
      @views v4=v4+f4(pool[i:i+4-1],pool[i+4:i+4+2-1],pool[i+4+2])
      i+=(4+2+1)
    end
    println("fun end\n\t",v4)
  end




end