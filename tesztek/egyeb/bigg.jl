let
  len=92
  M=big(2)^len
  n=rand(0:(M-1))
  step=10
  d=22
  for s in 1:step
    nn=digits(n,base=2,pad=len)|>reverse
    println(nn.|>string|>join," => ",n)
    n=(n+d)%M
  end
end



