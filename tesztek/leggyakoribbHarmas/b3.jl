using StatsBase
using Distributions

let


  function mread(fn)
    println("-----------------")
    println("read...")
    nC,nD,D=fill(nothing,3)
    open(fn,"r") do f
      nC,nD=parse.(Int, readline(f)|>split)
      D=[Set{Int}() for i in 1:nD] # a dobozok
      for i in 1:nD
        D[i]=Set(parse.(Int, readline(f)|>split))
      end
    end
    1:nC,D
  end


  function mwrite(C,D,mx)
    println("-----------------")
    println("write...")
    nC=length(C)
    nD=length(D)
    fn="C$(nC)_D$(nD)_mx$(mx).txt"
    open(fn, "w") do f
      println(f,nC," ",nD)
      for dob in D
        sdob=collect(dob) .|> string
        println(f,join(sdob," "))
      end
    end
  end



  # adat generalas
  function mgen(nC,cDist,nD,dDist)
    println("-----------------")
    println("generate...")
    C=1:nC # a szinek 

    wC=cDist(nC) 
  
    D=[Set{Int}() for i in 1:nD] # a dobozok
    sD=dDist(nC,nD)

    for i in 1:nD
      D[i]=Set(sample(C,wC,sD[i]))
    end

    C,D
  end

  function mfrek(C,D)
    println("-----------------")
    println("frek...")


    nC=length(C)
    frek1=fill(0,nC)
    for dob in D
      for v in dob
        frek1[v]+=1
      end
    end

    frek2=Dict()
    for dob in D
      sd=dob|>collect|>sort
      nsd=length(sd)
      for i in 1:nsd
        a=sd[i]
        for j in (i+1):nsd
          b=sd[j]
          frek2[(a,b)]=get(frek2,(a,b),0)+1
        end
      end
    end

    frek1,frek2
  end



  function mbruteforce(D)
    println("-----------------")
    println("bruteforce...")
    frek3=Dict()
    for dob in D
      vd=collect(dob)|>sort
      nvd=length(vd)
      for i in 1:nvd
        a=vd[i]
        for j in (i+1):nvd
          b=vd[j]
          for k in (j+1):nvd
            c=vd[k]
            frek3[(a,b,c)]=get(frek3,(a,b,c),0)+1
          end
        end
      end
    end
    frek3
  end # brute


  function mqbruteforce(C,D,frek1,frek2,p1,p2)
    println("-----------------")
    println("quantile based bruteforce...")

    q1=quantile(frek1,p1)
    qnodes=filter(x->frek1[x]>q1,C)
    q2=quantile(frek2 |> values,p2)

    nqC=length(qnodes)
    
    frek3=Dict()
    f3mx=0
    for i in 1:nqC
      a=qnodes[i]
      for j in i+1:nqC
        b=qnodes[j]
        (get(frek2,(a,b),0)<q2)&&continue
        for k in j+1:nqC
          c=qnodes[k]
          ((get(frek2,(a,c),0)<q2)||(get(frek2,(b,c),0)<q2)) && continue

          f3=0
          for dob in D
            f3+=if (a in dob)&&(b in dob)&&(c in dob) 1 else 0 end
          end
          if f3>=f3mx
            frek3[(a,b,c)]=f3
            q2=max(q2,f3)
          end
        end
      end
    end
    frek3,q1,q2
  end # qbrute


  function mrestart(D,frek1,frek2,mx)
    println("-----------------")
    println("restart...")

    nC=length(frek1)
    q2=mx+1
    qfrek2=Dict()
    for (k,v) in frek2
      if v>=q2
        qfrek2[k]=v
      end
    end
    println("arány: ",length(qfrek2)/length(frek2))


    frek3=Dict()
    f3mx=0
    for ((a,b),v) in qfrek2
      (v<q2)&&continue
      for c in 1:nC
        (c==a||c==b||frek1[c]<q2)&&continue
        aa,bb,cc=a,b,c
        if cc<bb 
          cc,bb=bb,cc
          if bb<aa
            bb,aa=aa,bb
          end
        end
        ((get(qfrek2,(aa,bb),0)<q2)||
          (get(qfrek2,(aa,cc),0)<q2)||
            (get(qfrek2,(bb,cc),0)<q2))&&continue

        f3=0
        for dob in D
          f3+=if (aa in dob)&&(bb in dob)&&(cc in dob) 1 else 0 end
        end
        if f3>0 && f3>=f3mx
          f3mx=f3
          frek3[(aa,bb,cc)]=f3
          q2=max(q2,f3)
        end

      end # for c
    
    end # for (a,b),v
    frek3,q2

  end # restart


  # a ciklusok felcserélve a restart-hoz képest
  function mrestart2(D,frek1,frek2,mx)
    println("-----------------")
    println("restart2...")

    nC=length(frek1)
    q2=mx+1
    qfrek2=Dict()
    for (k,v) in frek2
      if v>=q2
        qfrek2[k]=v
      end
    end
    println("arány: ",length(qfrek2)/length(frek2))


    frek3=Dict()
    f3mx=0
    for c in 1:nC
      (frek1[c]<q2)&&continue
      for ((a,b),v) in qfrek2
        (a==c||b==c||v<q2)&&continue
        if c<a
          a,b,c=c,a,b
        elseif c<b
          a,b,c=a,c,b
        end
        ((get(qfrek2,(a,c),0)<q2)||(get(qfrek2,(b,c),0)<q2))&&continue

        f3=0
        for dob in D
          f3+=if (a in dob)&&(b in dob)&&(c in dob) 1 else 0 end
        end
        if f3>0 && f3>=f3mx
          f3mx=f3
          frek3[(a,b,c)]=f3
          q2=max(q2,f3)
        end

      end # for (a,b),v
    
    end # for c
    frek3,q2

  end # restart2


  #lehet hogy erdemes lenne a teljes a2D-t felepiteni
  function mrestart3(D,frek1,frek2,mx)
    println("-----------------")
    println("restart3...")

    nD=length(D)
    nC=length(frek1)
    q2=mx+1
    qfrek2=Dict()
    for (k,v) in frek2
      if v>=q2
        qfrek2[k]=v
      end
    end
    println("arány: ",length(qfrek2)/length(frek2))


    frek3=Dict()
    for ((a,b),v) in qfrek2
      (v<q2)&&continue
      ab2D=[(a in D[i]) && (b in D[i]) for i in 1:nD]

      for c in 1:nC
        cc=c
        (c==a||c==b||frek1[c]<q2)&&continue
        if cc<a
          a,b,cc=cc,a,b
        elseif cc<b
          a,b,cc=a,cc,b
        end

        ((get(qfrek2,(a,b),0)<q2)||
          (get(qfrek2,(a,cc),0)<q2)||
            (get(qfrek2,(b,cc),0)<q2))&&continue

        f3=0
        for i in 1:nD
          f3+= if ab2D[i]&&(c in D[i]) 1 else 0 end
        end
        if f3>=q2
          frek3[(a,b,cc)]=f3
          q2=f3
        end

      end # for c
    
    end # for (a,b),v
    frek3,q2

  end # restart3




  # function cDist(nC)
  #   wC=rand(1:20,nC)
  #   wC=wC/sum(wC) |> Weights
  # end

  function cDist(nC)
    wC=sample(1:nC,nC,replace=false)
    wC=wC.^1.2 
    wC=wC/sum(wC) |> Weights
  end


  function dDist(nC,nD)
    A=max(15,0.2*nC)
    B=max(0.9*nC,A+5)
    dist=Uniform(A,B)
    # a dobozok meretei
    rand(dist,nD) .|> floor .|> Int
  end

  # generalas
  # nC=100
  # nD=100
  # tt=time()
  # C,D=mgen(nC,cDist,nD,dDist)
  # println(time()-tt," sec")

  # tt=time()
  # wr=false
  # C,D=mread("C200_D200_mx86.txt")
  # println(time()-tt," sec")


  # tt=time()
  # frek1,frek2=mfrek(C,D)
  # println(time()-tt," sec")



  # tt=time()
  # frek3=mbruteforce(D)
  # mx0=frek3 |> values |> maximum
  # println("max=",mx0)
  # println(time()-tt," sec")



  lista="""
  C200_D200_mx105.txt  C200_D200_mx86.txt   C300_D300_mx113.txt  C300_D400_mx147.txt
  C200_D200_mx76.txt   C200_D400_mx114.txt  C300_D300_mx141.txt  C400_D400_mx141.txt
  C200_D200_mx82.txt   C300_D300_mx110.txt  C300_D300_mx94.txt"""
  # lista="""
  # C200_D200_mx105.txt C200_D200_mx86.txt"""


  # wr=false
  # for fn in split(lista)
  #   println(fill('#',70)|>join)
  #   println("file:",fn)

  # #  tt=time()
  #   C,D=mread(fn)
  # #  println(time()-tt," sec")

  # #  tt=time()
  #   frek1,frek2=mfrek(C,D)
  # #  println(time()-tt," sec")
  
  #   tt=time()
  #   qfrek3,q1,q2=mqbruteforce(C,D,frek1,frek2,0.9,0.5)
  #   mx1=qfrek3 |> values |> maximum
  #   println("max1=",mx1)
  #   println(time()-tt," sec")
  #   println("q1=",q1)
  #   println("q2=",q2)

  #   tt=time()
  #   qfrek3,q2=mrestart(D,frek1,frek2,mx1)
  #   mx2=qfrek3 |> values |> maximum
  #   println("max2=",mx2)
  #   println(time()-tt," sec")
  #   println("q2=",q2)

  #   tt=time()
  #   qfrek3,q2=mrestart3(D,frek1,frek2,mx1)
  #   if length(qfrek3)>0
  #     mx3=qfrek3 |> values |> maximum
  #     println("max3=",mx2)
  #   else
  #     println("empty")
  #   end
  #   println(time()-tt," sec")
  #   println("q2=",q2)

  #   if true==wr
  #     datawrite(C,D,mx)
  #   end
  
  # end

  wr=true
  for k in 1:3
    println(fill('#',70)|>join)

    nC=rand(500:800)
    nD=rand(500:800)

    tt=time()
    C,D=mgen(nC,cDist, nD,dDist)
    println(time()-tt," sec")

    tt=time()
    frek1,frek2=mfrek(C,D)
    println(time()-tt," sec")
  
    tt=time()
    qfrek3,q1,q2=mqbruteforce(C,D,frek1,frek2,0.9,0.5)
    mx1=qfrek3 |> values |> maximum
    println("max1=",mx1)
    println(time()-tt," sec")
    println("q1=",q1)
    println("q2=",q2)

    tt=time()
    qfrek3,q2=mrestart3(D,frek1,frek2,mx1)
    mx3=mx1
    if length(qfrek3)>0
      mx3=qfrek3 |> values |> maximum
      println("max3=",mx3)
    else
      println("empty")
    end
    println(time()-tt," sec")
    println("q2=",q2)

    if true==wr
      mwrite(C,D,max(mx1,mx3))
    end
  
  end

end