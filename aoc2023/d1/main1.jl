function mysolve(fin, fout)
  s = 0
  for line in readlines(fin)
    s+= parse(
      Int,
      filter(x->isdigit(x), line)[[1,end]] |> join
    )
  end

  println(fout, s)
end




if abspath(PROGRAM_FILE)==@__FILE__
  mysolve(stdin, stdout)
end