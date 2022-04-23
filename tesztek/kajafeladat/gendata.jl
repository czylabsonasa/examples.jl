let
  for n in 2 .^ (3:20)
    S=rand(['M','H','H','H','K'],n)
    push!(S,'K') # sentinel

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
    open(string(n)*".out","w") do fin
      println(fin,gmx)
      println(fin,glo," ",gup)
    end
    open(string(n)*".in","w") do fin
      println(fin,n)
      println(fin,join(S[1:end-1]))
    end
  end
end
