
debug(x)=if dbg 
  println(stderr,x)
else
  nothing
end


function mksucc(maxy)
  function succ(x,y)
    y+=1
    (y>maxy)&&(x+=1;y=1)
    x,y
  end
end
