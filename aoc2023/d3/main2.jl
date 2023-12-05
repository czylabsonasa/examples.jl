function mysolve(fin, fout)
  # set borders
  table = [vcat('.', collect(v), '.') for v in readlines(fin)]
  C = length(table[1])
  table = [
    fill('.', C), 
    table..., 
    fill('.', C), 
  ]

  R = length(table)

  gears = Dict()
  function mypush(i, j, val)
    if !haskey(gears, (i,j))
      gears[(i,j)]=Int[]
    end
    push!(gears[(i,j)], val)
  end


  #display(data)

  for i in 2:R-1
    innum = 0
    thenum = 0

    for j in 2:C
      c = table[i][j]
      if isdigit(c)
        if innum>0
          thenum = 10*thenum + (c-'0')
          continue
        else
          innum = j
          thenum = (c-'0')
        end
      else
        if innum>0
          if c=='*'
            mypush(i, j, thenum)
          end
          if table[i][innum-1]=='*'
            mypush(i, innum-1, thenum)
          end
          for jj in innum-1:j
            if table[i-1][jj]=='*'
              mypush(i-1, jj, thenum)
            end
            if table[i+1][jj]=='*'
              mypush(i+1, jj, thenum)
            end
          end

          innum = 0
          thenum = 0
        end
      end
    end
  end

  s = 0
  for (k,v) in gears
    #println(stderr, v)
    if length(v)==2
      s += prod(v)
    end
  end


  println(fout, s)
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end