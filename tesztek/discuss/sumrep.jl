function sumofdoubles(values, p)
    s = 0
    counts = zeros(UInt16, p)
    @inbounds for value in values
        counts[value] += 1
    end
    @inbounds for (i, v) in enumerate(counts)
        (v > 1) && (s += i * v)
    end
    s
end

function sumofdoubles2(values, p)
  s = 0
  counts = fill(0, p)

  @inbounds for value in values
    s += value
    counts[value] += 1
    (counts[value] == 2) && (s -= value)
  end
  s
end

function sumofdoubles3(values, p)
  s = 0
  counts = fill(0, p)
  D=2
  f(i)=(
    counts[values[i]]+=1;counts[values[i+1]]+=1;
    # counts[values[i+2]]+=1;counts[values[i+3]]+=1;
    # counts[values[i+4]]+=1;counts[values[i+5]]+=1;counts[values[i+6]]+=1;counts[values[i+7]]+=1;
  )

  nv = length(values)
  
  @inbounds for i in 1:nv÷D
    f((i-1)*D+1)
  end
  for i in D*(nv÷D):nv
    counts[values[i]]+=1
  end
  @inbounds for (i, v) in enumerate(counts)
    (v > 1) && (s += i * v)
  end
  s
end


p = 10^4
x = rand(1:p, 10^8)

@time sumofdoubles(x, p) #68.616 ms (2 allocations: 19.64 KiB)

@time sumofdoubles2(x, p) #

@time sumofdoubles3(x, p) #
