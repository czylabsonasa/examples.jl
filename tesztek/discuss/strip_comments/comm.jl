function stripcomments(input, markers)
  out=[]
  markers=join(markers)
  for l in split(input, "\n")
    ll=split(l,x->(x in markers))
    if length(ll)>0
      push!(out,strip(ll[1]))
    end
  end
  join(out,"\n")
end

stripcomments("apples, plums % and bananas\npears\noranges !applesauce", ["%", "!"])|>println
