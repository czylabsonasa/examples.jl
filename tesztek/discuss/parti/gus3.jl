function combinations!(list, root, N; unique=true)
  if iszero(N)
      push!(list, root)
  end
  start = isempty(root) ? 1 : last(root) + unique
  for n = start:N
      arr = vcat(root, n)
      combinations!(list, arr, N-n)
  end
end

function combinations(N; unique=true)
  list = Vector{Int64}[]
  combinations!(list, Int64[], N; unique)
  return list
end

