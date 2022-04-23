using Distributions

let
  function vec(n,d1,d2)
    le=0
    while true
      (le>n)&&break
      le+=length(rand(d1,rand(d2)))
    end
    le
  end

  function mat(n,d1,d2)
    le=0
    while true
      (le>n)&&break
      le+=length(rand(d1,(rand(d2),1)))
    end
    le
  end

  d1=Beta(2, 2)
  d2=Poisson(22)

  vec(10,d1,d2);
  mat(10,d1,d2);

  tmat,tvec=0.0,0.0
  for k in 1:20
    t=time()
    vec(2^k,d1,d2)
    tvec+=time()-t;

    t=time()
    mat(2^k,d1,d2)
    tmat+=time()-t;
  end
  println("mat:",tmat)
  println("vec:",tvec)

end