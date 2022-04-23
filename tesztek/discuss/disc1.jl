using Random

function mkpars(n)
  y = fill(UInt8('_'),256);
  y[UInt8('A')] = UInt8('U');
  y[UInt8('C')] = UInt8('G');
  y[UInt8('G')] = UInt8('C');
  y[UInt8('T')] = UInt8('A');

  x = rand(UInt8.(['A','C','G','T']),n);
  [(x,y)]
end


function foo1(x,y)
    [ @inbounds y[c] for c in x ]
end

function foo2(x,y)
  z = x[:]
  for i in eachindex(z)
    @inbounds z[i] = y[x[i]]
  end
  z
end

function foo3(x,y)
  z = similar(x)
  i=1
  for c in x
    @inbounds z[i] = y[c]
    i+=1
  end
  z
end

function foo4(x,y)
  for i in eachindex(x)
    @inbounds x[i] = y[x[i]]
  end
end

foo5(x,y)=y[x]

foos=[foo1,foo2,foo3,foo4,foo5]


function tester(funs,pars,caller,rep)
  nfun=length(funs)
  T=fill(0.0,nfun)
  for r in 1:rep
    for f in shuffle(1:nfun)
      fun=funs[f]
      for par in pars
        t0=time()
        out=caller(fun,par)
        T[f]+=(time()-t0)
      end
    end
  end
  T./rep
end
