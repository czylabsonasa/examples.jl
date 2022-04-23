let
  m = Channel{Float64}(1)
  put!(m, Inf)


  m1 = Inf
  t1 = @task begin 
    for i in 1:1000
      v = rand()
      m1 = min(m1, v)
      if v<fetch(m)
        take!(m)
        put!(m,v)
      end
    end
  end


  m2 = Inf
  t2 = @task begin 
    for i in 1:10000
      v = rand()
      m2 = min(m2, v)
      if v<fetch(m)
        take!(m)
        put!(m,v)
      end
    end
  end

  

  schedule.([t1,t2])



  wait.([t1,t2])

  ret=(m1, m2, fetch(m))

  close(m)
  ret
  
end

