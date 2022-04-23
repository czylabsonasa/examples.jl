module user
  export comp, simpmult, flatmult, threadmult

  include("lib.jl")
  using .lib
  simpsc,flatsc,dim=readsc("sc_table.jld2")
  simpmult,flatmult,threadmult=mkmult(simpsc,flatsc)

  function mkcomp(dim)
    function comp(K,mult)
      for _ in 1:K
        x,y,z=rand(-10:10,dim),rand(-10:10,dim),rand(-10:10,dim)
        res=mult(mult(x, y),z) + mult(mult(y,z),x) + mult(mult(z, x), y)
        @assert sum(res)==0
      end
    end
  end

  comp=mkcomp(dim)

end