function gustaphe(npre=16)
  pre=[[] for _ in 1:npre]
  pre[1]=[[1]]
  pre[2]=[[2]]
  pre[3]=[[3],[1,2]]
  pre[4]=[[4],[1,3]]

  for k=5:npre
    pk=[[k]]
    for s in 2:k-1
      for v in pre[k-s]
        if v[end]<s
          push!(pk,vcat(v,s))
        end
      end
    end
    pre[k]=pk
  end


  function combinations!(list, root, N)
    if length(root)>0 && 0<N<=npre
      l=root[end]
      for v in pre[N]
        if v[1]>l
          push!(list,vcat(root,v))
      end
      end
      return list
    end

    start = (length(root)==0 ? 0 : last(root)) + 1
    for n = start:N
      arr = vcat(root, n)
      combinations!(list, arr, N-n)
    end
  end
  function combinations(N)
    list = Vector{Int64}[]
    combinations!(list, Int64[], N)
    return list
  end


  combinations,pre
end
