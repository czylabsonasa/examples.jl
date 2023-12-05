function mysolve(fin, fout)
  # set borders
  cards = []
  for line in readlines(fin)
    line = split(split(line, ':')[2],'|')
    push!(
      cards, 
      (
        small=parse.(Int, split(line[1])), 
        large = parse.(Int, split(line[2])) 
      )
    )
  end
  # println(stderr, cards)


  s = 0
  for x in cards
    is = length(intersect(x.small, x.large))-1
    (is>=0) && (s += 2^is)
  end


  println(fout, s)
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end