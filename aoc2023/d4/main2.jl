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


  C = length(cards)
  total = fill(1, C)
  for i in 1:C-1
    is = length(intersect(cards[i].small, cards[i].large))
    (is<1) && continue    
    total[i+1:min(i+is,C)] .+= total[i]
  end


  println(fout, sum(total))
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end