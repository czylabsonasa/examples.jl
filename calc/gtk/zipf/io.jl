read_data(fname) = open(fname, "r") do rd
  split(read(rd, String), x->!isletter(x), keepempty=false) .|> lowercase
end
