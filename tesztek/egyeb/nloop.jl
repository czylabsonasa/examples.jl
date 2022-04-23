function test3(v::Val{N}) where {N}
  p2 = reverse(ntuple(i->2^(i-1), v))
  for idx in CartesianIndices(ntuple(i->0:1, v))
      ridx = reverse(Tuple(idx))
      n = sum(ridx .* p2)
      println(ridx[1], ridx[2], ridx[3], " => ", n)
  end
end