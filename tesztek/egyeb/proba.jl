let
  f(t,y) = cos(2*t)*y + (3*t^2+3*t-1) ;
  
  
  t0 = 0 ; y0 = -2 ;
  tv = 2 ;
  
  n = 3 ;
  
  h = (tv - t0) / n ;

  y = y0 ; t = t0 ;
  for k=1:n
    y = y + f(t,y)*h
    t = t + h
  end
  println(y)
end