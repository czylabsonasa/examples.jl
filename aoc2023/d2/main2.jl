function mysolve(fin, fout)
  mins = Dict(
    "red" => 0,
    "green" => 0, 
    "blue" => 0,
  )
  init()=mins["red"]=mins["green"]=mins["blue"]=0
  val()=mins["red"]*mins["green"]*mins["blue"]


  s = 0
  for (idx,line) in enumerate(readlines(fin))
    G = split(split(line,':')[2], ';')
    init()
    for mutat in G
      m = split(map(x->x == ',' ? ' ' : x, mutat),' ',keepempty=false)
      for i in 1:2:length(m)
        mins[m[i+1]] = max(mins[m[i+1]], parse(Int, m[i]))
      end
    end
    s += val()
  end

  println(fout, s)
end


if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end
