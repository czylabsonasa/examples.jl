# kmean.jl

using 
  Winston, 
  Parameters

let
  D = 2
  K = 2
  N = 20
  points = rand(D, N)
  gr = rand(1:K, N)
  
  cgr = fill(0.0, D, K)
  ngr = fill(0, K)  


  for n in 1:N
    cgr[:, gr[n]] .+= points[:, n]
    ngr[gr[n]] += 1
  end

  cgr ./= ngr  


  function toplot()
    pcol = ["ro", "go", "bo", "yo"]
    ccol = ["rx", "gx", "bx", "yx"]
    p=plot()
    for n in 1:N
      oplot([points[1,n]], [points[2,n]], pcol[gr[n]])
    end

    for k in 1:K
      oplot([cgr[1,k]], [cgr[2,k]], ccol[k])
    end

    display(p)
  end
  toplot()


  
  oldcgr = similar(cgr)
  oldngr = similar(ngr)
  
  
  tol = 1e-6

  while true
    oldcgr .= cgr
    cgr .= 0.0
    oldngr .= ngr

    for n in 1:N
      g = gr[n]
      c = argmin([(oldcgr[:,k]-points[:,n]).^2 |> sum for k in 1:K])
      cgr[:,c] += points[:,n]
      if c != g
        gr[n]=c
        ngr[c] += 1
        ngr[g] -= 1
      end
    end

    cgr ./= ngr

    toplot()
    d = (cgr - oldcgr).^2 |> sum 
    println(d)
    
    if d < tol
      break
    end
  end

end

