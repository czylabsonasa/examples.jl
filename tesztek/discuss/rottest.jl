using StaticArrays, BenchmarkTools

function rotate!(v)
  M = MMatrix{2,2,Float64}(0,0,0,0)
  for i in 1:length(v)
    θ = 2π*rand()
    M[1,1] = cos(θ)
    M[1,2] = -sin(θ)
    M[2,1] = sin(θ)
    M[2,2] = cos(θ)
    v[i] = M*v[i]
  end
end

function rotate2!(v)
  # M = MMatrix{2,2,Float64}(0,0,0,0)
  for i in 1:length(v)
    Θ = 2π*rand()
    # M[1,1] = cos(θ)
    # M[1,2] = -sin(θ)
    # M[2,1] = sin(θ)
    # M[2,2] = cos(θ)
    v[i] = MMatrix([cos(Θ) -sin(Θ); sin(Θ) cos(Θ)])*v[i]
  end
end


v = [ rand(SVector{2,Float64}) for i in 1:100 ]

