function mysolve(fin, fout)

  data=Dict()
  for part in split(read(fin, String),"\n\n")
    tip, nums = split(part,':')
    tip = strip(tip)
    nums = parse.(Int, split(nums))
    if tip == "seeds"
      data["seeds"] = nums
    else
      tip = split(tip)[1]
      dtip = []
      for i in 1:3:length(nums)
        push!(dtip, (fr = nums[i+1], to = nums[i], len = nums[i+2]))
      end
      data[tip] = dtip
    end
  end

  # display(data)
  
  state = Set(data["seeds"])

  steps = [
    "seed-to-soil", 
    "soil-to-fertilizer", 
    "fertilizer-to-water", 
    "water-to-light", 
    "light-to-temperature",
    "temperature-to-humidity",
    "humidity-to-location",
  ]
  for step in steps
    nxt = Set{Int}()
    for x in state
      volt = false
      for s in data[step]
        if s.fr <= x < s.fr + s.len 
          volt = true
          push!(nxt, s.to + x - s.fr)
        end
      end
      if volt == false
        push!(nxt, x)
      end
    end
    state = nxt
  end

  println(fout, minimum(state))
end


if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end