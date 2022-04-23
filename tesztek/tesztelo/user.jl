include("solution.jl")

function user(IN)
  res=[]
  timing=[]
  for lin in readlines(IN)
    mt=time()
    r=solution(lin)
    mt=time()-mt
    push!(res,r)
    push!(timing,mt)
    #println(ret, " ",mt)
  end
  open(IN*".res","w") do f
    for r in res
      println(f,r)
    end
  end
  open(IN*".timing","w") do f
    for t in timing
      println(f,t)
    end
  end

end
user(ARGS[1])
