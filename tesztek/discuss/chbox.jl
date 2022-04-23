struct Box
  k::Int
end

struct Room{T} <: AbstractVector{T}
  v::Vector{Box}
end
Base.getindex(room::Room{Int},i) = room.v[i].k
Base.size(room::Room{Int}) = size(room.v)
Base.length(room::Room{Int}) = length(room.v)

room = [ Box(rand(Int)) for i in 1:1000 ];

using StatsBase, BenchmarkTools

function chooseBox(room::Vector{Box})
  v = [x.k for x in room]
  sample(room, Weights(v))
end

function chooseBox2(room::Vector{Box})
  v = Room{Int}(room)
  sample(room, Weights(v))
end

function chooseBox3(room::Vector{Box})
  v = Room{Int}(room)
  sample(@view(room[1:end]), Weights(v))
end


@btime chooseBox($room)

@btime chooseBox2($room)

@btime chooseBox3($room)
