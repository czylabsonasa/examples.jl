using StatsBase, OffsetArrays, Plots

valaszt(ebbol,ennyit)=sample(ebbol,ennyit,replace=false,ordered=false)

function haromszoges(P,Q,R,nLEP)
  Tri=fill(0,nLEP,3)
  nTri=-1
  nV=-1
  function init()
    Tri[1,:]=[1,2,3]
    nTri=1
    nV=3
  end
  function sim()
    init()
    while nTri<nLEP
      a,b,c,nV=
      if rand()<P
        (if rand()<R
          valaszt(Tri[rand(1:nTri),:],2)
        else
          valaszt(1:nV,2)
        end...,nV+1,nV+1)
      else
        (if rand()<Q
          Tri[rand(1:nTri),:]
        else
          valaszt(1:nV,3)
        end...,nV)
      end
      nTri+=1
      Tri[nTri,:]=[a,b,c]
    end #w(lep)
    result() 
  end
  
  function result()
    v2w=fill(0,nV) # csucs -> suly
    for v=Tri 
      v2w[v]+=1 
    end
    maxw=maximum(v2w)
    frek=fill(0,maxw)
    for v=1:nV
      frek[v2w[v]]+=1
    end
    ww,fww=[],[]
    for v=1:maxw
      if frek[v]>0
        push!(ww,v)
        push!(fww,frek[v])
      end
    end
    @assert sum(fww)==nV
    ww,fww
  end

  sim
end


function work(P,Q,R,nLEP,plo,phi,name)
  alfa=2/3*P*R+(1-P)*Q
  slope=-(1+1/alfa)


  ww,fww=haromszoges(P,Q,R,nLEP)() # sulyok es kapcsolodo gyakorisagok

  println(length(ww))

  numw=length(ww)
  totw=sum(fww) # =nV
  fww=fww/totw

  # csak ket "magas" quantilis kozti teruletet nezunk. w->\infty
  s=0
  ilo=1
  while s<plo && ilo<numw s+=fww[ilo]; ilo+=1 end
  ihi=ilo
  while s<phi && ihi<numw s+=fww[ihi]; ihi+=1 end


  # mu=sum(ww.*fww)
  # sigma=sqrt(mean((ww.-mu).^2))
  lww=log.(ww)
  lfww=log.(fww)
  minlfww,maxlfww=extrema(lfww)
  kpx,kpy=mean(lww[ilo:ihi]),mean(lfww[ilo:ihi])
  tline(z)=slope*z+kpy-slope*kpx

  hiba=sqrt(mean( (tline.(lww[ilo:ihi]).-lfww[ilo:ihi]).^2))

  ptit="""
  p, q, r, ev.steps = $(P), $(Q), $(R), $(nLEP)
  exp, err = $(round(slope,digits=2)), $(round(hiba,digits=3))
  pLo, pHi = $(plo), $(phi)"""

  #plot(legend=false,title="p, q, r, step, exp = $(P), $(Q), $(R), $(nLEP), $(round(slope,digits=2))\n pLo, pHi = $(plo), $(phi)\n")
  plot(legend=false,title=ptit)


  #plot([log(mu),log(mu)],[minlfww,maxlfww])
  plot!([log(ww[ilo]),log(ww[ilo])],[minlfww,maxlfww],color="black")
  plot!([log(ww[ihi]),log(ww[ihi])],[minlfww,maxlfww],color="black")

  n=length(lww)
  scatter!(lww,lfww,markersize=2)
  scatter!(lww[ilo:ihi],lfww[ilo:ihi],markersize=3,color="orange")


  scatter!([kpx],[kpy],markersize=5)


  balx,jobbx=0,maximum(lww)
  plot!([balx,jobbx],[tline(balx),tline(jobbx)])
#  plot!(legend=false)

  savefig(name*".pdf")
end

function workXY(P,Q,R,nLEP,plo,phi,name)
  alfa=2/3*P*R+(1-P)*Q
  slope=-(1+1/alfa)


  X,Y=haromszoges(P,Q,R,nLEP)() # sulyok es kapcsolodo gyakorisagok

  nX=length(X)
  println(nX)

  sY=sum(Y) # = num of vertices
  Y=Y/sY

  # csak ket "magas" quantilis kozti teruletet nezunk. w->\infty
  s=0
  ilo=1
  while s<plo && ilo<nX s+=Y[ilo]; ilo+=1 end
  ihi=ilo
  while s<phi && ihi<nX s+=Y[ihi]; ihi+=1 end


  lX=log.(X)
  lY=log.(Y)
  minlY,maxlY=extrema(lY)
  clx,cly=mean(lX[ilo:ihi]),mean(lY[ilo:ihi])
  tline(z)=slope*z+cly-slope*clx

  hiba=mean( (tline.(lX[ilo:ihi]).-lY[ilo:ihi]).^2)

  ptit="""
  p, q, r, ev.steps = $(P), $(Q), $(R), $(nLEP)
  exp, meanerr2 = $(round(slope,digits=2)), $(round(hiba,digits=3))
  pLo, pHi = $(plo), $(phi)"""

  #plot(legend=false,title="p, q, r, step, exp = $(P), $(Q), $(R), $(nLEP), $(round(slope,digits=2))\n pLo, pHi = $(plo), $(phi)\n")
  plot(legend=false,title=ptit)


  plot!([lX[ilo],lX[ilo]],[minlY,maxlY],color="black")
  plot!([lX[ihi],lX[ihi]],[minlY,maxlY],color="black")

  scatter!(lX,lY,markersize=2)
  scatter!(lX[ilo:ihi],lY[ilo:ihi],markersize=3,color="orange")


  scatter!([clx],[cly],markersize=5)


  balx,jobbx=0,maximum(lX)
  plot!([balx,jobbx],[tline(balx),tline(jobbx)])
#  plot!(legend=false)

  savefig(name*".pdf")
end
