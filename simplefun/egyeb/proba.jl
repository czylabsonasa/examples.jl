mutable struct Proba
  x::Int
  f::Function
  # function Proba()
    # this.x=this.f(this.x)
  # end
end
function (p::Proba)()
  p.x = p.f(p.x)
end
