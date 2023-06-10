function compute(data)
  debug("compute")
  frek = countmap(data)
  sfrek = sort([(k,v) for (k,v) in frek], by = x->-x[2])
  y = [s[2] for s in sfrek]
  y = log.(y ./ sum(y))
  x = log.(1:length(y))
  x, y
end
