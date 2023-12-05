# ranges are pushed through the pipe

function mysolve(fin, fout)

  data=Dict()
  for part in split(read(fin, String),"\n\n")
    tip, nums = split(part,':')
    tip = strip(tip)
    nums = parse.(Int, split(nums))
    if tip == "seeds"
      data["seeds"] = Set([nums[i]:nums[i]+nums[i+1]-1 for i in 1:2:length(nums)])
    else
      tip = split(tip)[1]
      dtip = []
      for i in 1:3:length(nums)
        push!(dtip, (fr = nums[i+1]:nums[i+1]+nums[i+2]-1, to = nums[i]:nums[i]+nums[i+2]-1))
      end
      data[tip] = dtip
    end
  end

  # display(data)
  
  state = data["seeds"]

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
    nxt = Set{UnitRange}()
    for x in state
      for s in data[step]
        if x.stop < s.fr.start || s.fr.stop < x.start # no intersection
          push!(nxt, x)
          continue
        end
        xs = max(x.start, s.fr.start):min(x.stop,s.fr.stop) + s.to.start - s.fr.start

      end
    end
    state = nxt
  end

  println(fout, minimum(state))
end


if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end