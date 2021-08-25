#
# traversing an Expr tree
# https://github.com/dpsanders/julia_towards_1.0/blob/master/4.%20Metaprogramming.ipynb


# ind: indent
function trav(elem, ind = "") 
  println("$(ind)$(elem) $(typeof(elem))")
  if isa(elem, Expr)
    for arg in elem.args
      trav(arg,ind*"  ")
    end
  end
end


#
# traversing the DataType hierarchy
# 

function subtrav(tip, ind = ""; maxdepth = typemax(Int))
  (maxdepth < 0) && return
  println("$(ind)$(tip)")
  for t in subtypes(tip)
    subtrav(t, "  "*ind, maxdepth = maxdepth-1)
  end
end

# just for completeness (we have supertypes)
function suptrav(tip, ind = ""; maxdepth = typemax(Int))
  (maxdepth < 0) && return
  println("$(ind)$(tip)")
  (tip == Any) && return
  suptrav(supertype(tip), "  "*ind, maxdepth = maxdepth-1)
end

function lca(t1, t2)
  intersect(supertypes(t1),supertypes(t2))[1]
end


