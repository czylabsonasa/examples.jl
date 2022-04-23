let
  function counter(f)
      count = Ref(0)
      function (args...; kwargs...)
          count[] += 1
          f(args...; kwargs...)
      end, count
  end

  f1,c1=counter(sin)
  f2,c2=counter(cos)

  for k in 1:1000
    if rand()<0.5
      f1(rand())
      c1[]-=1
    else
      f2(rand())
    end
  end

  println(c1, " ", c2)
end