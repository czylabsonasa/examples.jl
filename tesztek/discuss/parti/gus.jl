function gustaphe_combinations!(list, root, N; unique=true)
  if iszero(N)
      return push!(list, root)
  end
  start = isempty(root) ? 1 : last(root) + unique
  for n = start:N
      arr = vcat(root, n)
      gustaphe_combinations!(list, arr, N-n)
  end
end

function gustaphe_combinations(N; unique=true)
  list = Vector{Int64}[]
  gustaphe_combinations!(list, Int64[], N; unique)
  return list
end

