f1(x)=x
f2(x,y)=x+y

function f(x...)
  if length(x)==0
    return 0
  end
  if length(x)==1
    return f1(x...)
  end
  if length(x)==2
    return f2(x...)
  end
end
