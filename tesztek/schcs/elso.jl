using Nemo 

f_fmpq = function( k::Int64 )
  s = fmpq(0)
  for i in 1:k
    addeq!(s,fmpq(1//i))
  end
  return s
end

f_fmpq2(k) = sum( fmpz(1) .// (1:k) )
f_fmpq3(k) = sum(fmpq.(1 .// (1:k))) # nalam ez a leggyorsabb
f_fmpq4(k) = (
  x = (1:2:k-1); y = (2:2:k);
  sum(fmpq.( (x .+ y) .// (x .* y)) ) +
    if k%2>0 fmpq(1//k) else fmpq(0) end
)


f_bigint0 = function( k::Int64 )
  s = 0//big(1)
  for i in 1:k
    s += 1//i
  end
  s
end

f_bigint2(k)=sum( 1 .// (big(1):k) )

f_bigint3(k)=(
  x = (big(1):2:k-1); y = (big(2):2:k);
  sum((x .+ y) .// (x .* y)) +
    if k%2>0 big(1)//k else big(0)//1 end
)

f_bigint4(k)=sum( big(1//i) for i in 1:k )

function f_bigint5(k; lim=32)
  function bigint5(l::BigInt,r::BigInt)
    if r-l<lim
      sum(1 .// (l:r))
    else
      m = (r+l)>>1
      bigint5(l,m)+bigint5(m+1,r)
    end
  end
  bigint5(big(1),big(k))
end


p(s)=print(lpad(s,10))
function testall(N)
  res = []
  # p("bigint2:"); @time push!(res, f_bigint2( N ))
  p("bigint3:"); @time push!(res, f_bigint3( N ))
  # p("bigint4:"); @time push!(res, f_bigint3( N ))
  p("bigint5:"); @time push!(res, f_bigint5( N, lim = 4 ))

  #p("fmpq:"); @time push!(res, f_fmpq( N ));
  # p("fmpq2:"); @time push!(res, f_fmpq2( N ))
  p("fmpq3:"); @time push!(res, f_fmpq3( N ))
  p("fmpq4:"); @time push!(res, f_fmpq4( N ))

  #display(res)
  @assert 1 == (fmpq.(res) |> Set |> length)

end
