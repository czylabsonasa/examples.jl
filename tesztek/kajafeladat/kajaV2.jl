# https://cdn.discordapp.com/attachments/681212677816844289/835532369716707328/feladat.pdf

let
  n,S=read(stdin,String) |> split .|> strip
  n=parse(Int,n)
  S=collect(S)
  push!(S,'K') # sentinel
  # println(n," ",S)

  gmx=0 # global opt
  glo,gup=-1,-1
  lmx=0 # local opt (mint a max subset sum-nál)
  nh=0 # az olyan M-ek szama amit h-ként használunk
  nop=0 # ennyi köret van éppen nála
  lo=1
  up=0
  while true
    up+=1
    (up>n)&&break
    if S[up]=='K'
      nop+=1
      continue
    end
    if S[up]=='M'
      if nop==0
        nop=1
      else
        nh+=1
        nop-=1
        lmx+=1
        if lmx>gmx
          gmx=lmx
          glo,gup=lo,up
        end
      end
      continue
    end
    if S[up]=='H'
      if nop>0
        nop-=1
        lmx+=1
        if lmx>gmx
          gmx=lmx
          glo,gup=lo,up
        end
      else
        if nh>0
          nh-=1
          nop+=1
          continue
        else
          lo=up+1
          while S[lo]!='K' && S[lo]!='M'
            lo+=1
          end
          up=lo-1
          lmx=0
          # nh=0
        end
      end
    end
  end

  println(gmx)
  println(glo," ",gup)
end
