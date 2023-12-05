function mysolve(fin, fout)
  lims = Dict(
    "red" => 12,
    "green" => 13, 
    "blue" => 14,
  )

  s = 0
  for (idx,line) in enumerate(readlines(fin))
    G = split(split(line,':')[2], ';')
    for mutat in G
      m = split(map(x->x == ',' ? ' ' : x, mutat),' ',keepempty=false)
      for i in 1:2:length(m)
        if parse(Int, m[i])>lims[m[i+1]]
          idx = 0
          break
        end
      end
      (idx == 0) && break
    end
    s += idx
  end

  println(fout, s)
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end