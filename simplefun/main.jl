#
# create a function like structure from an expression given as string
#
#
# https://github.com/dpsanders/julia_towards_1.0/blob/master/4.%20Metaprogramming.ipynb
# https://www.johnmyleswhite.com/notebook/2013/01/07/symbolic-differentiation-in-julia/
# https://docs.julialang.org/en/v1/manual/methods/#Function-like-objects-1

function trav(ex, ind="")
  if (ex isa Expr)
    println("$(ind)$(ex.args)")  
    for arg in ex.args
      trav(arg,ind*"  ")
    end
  end
end

# create the array of "variables" in an expression
function expr2var!(ex, symbols)
    # nothing here!, handle atoms other than Symbol
end

function expr2var!(ex::Symbol, symbols)
  push!(symbols, ex)
end
        

function expr2var!(ex::Expr, symbols)
  for arg in ex.args[1 + ( (ex.head == :call) ? 1 : 0 ) : end] # 
    expr2var!(arg, symbols) 
  end
end

function expr2var(ex::Expr) 
    symbols = Symbol[]
    expr2var!(ex, symbols)
    
    return symbols |> unique |> sort
end    


function expr2fun(ex::Symbol)
  pars = Expr(:tuple, ex)
  eval(:($pars -> $ex))
end


function expr2fun(ex::Expr)
  pars = Expr(:tuple, expr2var(ex)...)
  eval(:($pars -> $ex))
end

function expr2fun(sex::String)
  expr2fun(Meta.parse(sex))
end


# here we do not need mutability
# mutable struct Simplefun
  # str::String
  # var::Array{Symbol}
  # f::Function
  # function Simplefun(str::String)
    # this = new()
    # this.str = str
    # ex = Meta.parse(str)
    # this.var = expr2var(ex)
    # this.f = expr2fun(ex)
    # this
  # end
# end

struct Simplefun
  str::String
  var::Array{Symbol}
  f::Function
  function Simplefun(str::String)
    ex = Meta.parse(str)
    new(str, expr2var(ex), expr2fun(ex))
  end
end

# let Simplefun behave as a plain function
function (sf::Simplefun)(x...)
  sf.f(x...)
end
