let 
  naplo="""
  # 01 15
  Galagonya Alfonz OXXXXXN
  # 01 16
  Alma Hedvig OOOOOIO
  Galagonya Alfonz XXXXXXX
  """

  dnaplo=Dict()
  mm,dd=0,0
  for l in split(naplo,"\n",keepempty=false) .|> strip
    if l[1]=='#'
      mm,dd=parse.(Int,l[2:end]|>split)
      dnaplo[(mm,dd)]=get(dnaplo,(mm,dd),Dict())
      continue
    end
    l=split(l," ",keepempty=false)
    dnaplo[(mm,dd)][join(l[1:end-1]," ")]=l[end]
  end

  println(dnaplo)
end
