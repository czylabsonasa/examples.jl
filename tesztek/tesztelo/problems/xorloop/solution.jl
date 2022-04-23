function solution(data)
  a1,b1,a2,b2=parse.(Int, split(data))
  ret=0
  for i in a1:b1, j in a2:b2
    ret+=xor(i,j)
  end
  ret
end  
