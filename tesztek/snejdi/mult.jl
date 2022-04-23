#function mkmult(simpsc::Vector{Tuple{Int,Int,Vector{Tuple{Int,Int}}}}) # nalam nem gyorsabb igy
function mkmult(simpsc)
  function mult(xc, yc)
    dim=length(xc)                
    res=fill(0, dim)
    for (i,j,scij) in simpsc
      for k in scij
        res[k[2]] += (xc[i]*yc[j]-yc[i]*xc[j])*k[1]
      end  
    end 
    res
  end     

  mult
end

using JLD2
function mkmult(fname::String)
  sc=load(fname)["sc"]
  dim,_=size(sc)
  simpsc=typeof((1,1,sc[1,1]))[]
  for i in 1:dim, j in i+1:dim
    if length(sc[i,j])>0
      push!(simpsc,(i,j,sc[i,j]))
    end
  end
  mkmult(simpsc),dim
end

mult,dim=mkmult("sc_table.jld2")
function comp(K)
  for _ in 1:K
    x,y,z=rand(-10:10,dim),rand(-10:10,dim),rand(-10:10,dim)
    res=mult(mult(x, y),z) + mult(mult(y,z),x) + mult(mult(z, x), y)
    @assert sum(res)==0
  end
end
