module lib
  using Base.Threads

  export mkmult, readsc

  function mkmult(simpsc,flatsc)
    function simp(xc, yc)
      dim=length(xc)                
      res=fill(0, dim)
      for (i,j,scij) in simpsc
        for k in scij
          res[k[2]] += (xc[i]*yc[j]-yc[i]*xc[j])*k[1]
        end  
      end 
      res
    end     

    function flat(xc, yc)
      dim=length(xc)                
      res=fill(0, dim)
      for (k2,i,j,k1) in flatsc
          res[k2] += (xc[i]*yc[j]-yc[i]*xc[j])*k1
      end 
      res
    end     
    
    function flatthread(xc, yc)
      dim=length(xc)                
      res=fill(0, dim)
      @threads for (k2,i,j,k1) in flatsc
          res[k2] += (xc[i]*yc[j]-yc[i]*xc[j])*k1
      end 
      res
    end     

    (simp=simp,flat=flat,flatthread=flatthread)
  end

  using JLD2
  function readsc(fname::String)
    sc=load(fname)["sc"]
    dim,_=size(sc)
    simp=typeof((1,1,sc[1,1]))[]
    flat=typeof((1,1,1,1))[] # ezt elozoleg mar tudni kellene hogy milyen tipusu

    for i in 1:dim, j in i+1:dim
      if length(sc[i,j])>0
        push!(simp,(i,j,sc[i,j]))
        for k in sc[i,j]
          push!(flat,(k[2],i,j,k[1]))
        end
      end
    end
    sort!(flat)
    (simp=simp,flat=flat,dim=dim)
  end

end

