# szimplex.jl
# Rational{T}-vel számolunk

struct Table{T}
  ncon::Int
  nvar::Int
  invec::Vector{Int}
  outvec::Vector{Int}
  tab::Matrix{T}
end

struct Problem{T}
  A::Matrix{T}
  ops::Vector{String} 
  b::Vector{T}
  obj::Vector{T}
  sense::String #max or min
end

RI = Rational{Int}
# RBI : rational bigint
# Float?

function mstring(x::RI)::String
  out=string(x.num)
  (x.den != one(RI)) && (out = out*"/"*string(x.den))
  out
end
Base.string(x::RI) = mstring(x::RI)

function rparse(T::Type, x)
  s = split(x, "/", keepempty = false)
  a = parse(T, s[1])
  b = if 2==length(s)
    parse(T, s[2])
  else
    one(T)
  end

  @assert b != zero(T)
  a // b
end
#Base.parse(RI, x)::RI = rparse(Int, x)
#Base.tryparse(RI, x)::RI = rparse(Int, x)
  

function readProblem(file::String; T=Int) # T: input/output type of data
  status = true
  sense = nothing
  pA,op,b,obj = [[] for _ in 1:4]

  for l in eachline(file)
    lin = strip(l)
    ( (length(lin) == 0) || (lin[1] == '#') ) && continue
    s = split(lin, ":") .|> strip

    (length(s) != 2) && (status=false; break)

    if s[1] == "sense"
      sense = s[2]
      !(sense in ["min", "max"]) &&  (status=false; break)
    elseif s[1] == "obj"
      obj = rparse.(T, split(s[2]," ", keepempty=false))
    elseif s[1] == "con"
      s2 = s[2]
      i = findfirst(x-> x in "<=>", s2)
      (i == nothing) &&  (status=false; break)
      push!(op,s2[i])
      al,bl = split(s[2], s2[i])
      al = split(al, " ", keepempty=false) .|> strip

      pA = [pA, rparse.(T, al)]
      b = [b; rparse(T, bl)]
    else
      status=false; break
    end
  end
  display(pA)
  @assert true==status
  @assert 1 == (length.(pA) |> unique |> length)
  @assert length(pA[1])==length(obj)

  status, pA, op, b, obj, sense
end
