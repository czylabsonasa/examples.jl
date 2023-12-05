function mysolve(fin, fout)
  # set borders
  data = [vcat('.', collect(v), '.') for v in readlines(fin)]
  data = [
    fill('.',length(data[1])), 
    data..., 
    fill('.',length(data[1])), 
  ]

  #display(data)

  s = 0
  for i in 2:length(data)-1
    innum = 0
    thenum = 0
    di = data[i]
    for (j,c) in enumerate(di)
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
          #println(stderr, innum, " ", thenum)
          border = filter(
            x->!(isdigit(x) || x=='.'), 
            vcat( data[i-1][innum-1:j], di[innum-1], c, data[i+1][innum-1:j])
          )

          if length(border)>0
            s += thenum
          end

          innum = 0
          thenum = 0
        end
      end
    end
  end

  println(stderr, length(data[1]), " ", length(data))

  println(fout, s)
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end