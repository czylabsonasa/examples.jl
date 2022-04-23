using 
  LinearAlgebra, 
  DifferentialEquations, 
  SparseArrays, 
  Statistics,
  Plots,
  BenchmarkTools

function mkfun()  
  tstart =0.
  tstep=1.
  tfinal=2.
  tarray=tstart:tstep:tfinal;

  xvec=-50.:0.5:50.;yvec=-50.:0.5:50.; 
  Nx=length(xvec);Ny=length(yvec);N=Nx*Ny;
  X=xvec'.*ones(Ny); Y=ones(Nx)'.*yvec;


  ħ=0.6591; 
  c = 300.;  
  m0 = 511. * 1e6/c^2; 

  m=1e-5*m0;
  g=1e-4;
  t0=7.;
  l0=sqrt(ħ*t0/(2*m));

  xvectilde=xvec/l0; yvectilde=yvec/l0;
  gridsize=(xvectilde[2]-xvectilde[1]); 
  @assert ((yvectilde[2]-yvectilde[1])==gridsize);#Have to use a uniform grid for the derivative in the kinetic E
  Xtilde=xvectilde'.*ones(Ny); Ytilde=ones(Nx)'.*yvectilde;

  V0orig=2.; 
  Vtilde0=V0orig*t0/ħ;
  gtilde=g*2*m/ħ^2;

  dist=10.;
  Nspots=4;
  L=zeros(Nspots,2)
  for ss=1:Nspots
      L[ss,:]=dist*[cos(2*pi/Nspots*ss+pi/2),sin(2*pi/Nspots*ss+pi/2)];
  end

  Ltilde=L/l0;
  pumpwidth=4;pumpwidthtilde=pumpwidth/l0; 
  Pfun=zeros(Nx,Nx); 
  pumpidx=zeros(Int64,Nspots,1);
  pumpstrength=1;
  for pp=1:size(L,1)
    thispump=pumpstrength*exp.(-((Xtilde .- Ltilde[pp,1]).^2 .+ (Ytilde.- Ltilde[pp,2]).^2)./(2*pumpwidthtilde.^2)); #The exponent can remain dimensionful (micron) without problems (I think)
    Pfun = Pfun +thispump;
    ~,thispumpidx=findmax(thispump[:]);
    pumpidx[pp]=thispumpidx
  end

  middle=mean(L,dims=1);
  ~,centreidx=findmin((middle[1].-X[:]).^2+(middle[2].-Y[:]).^2);


  V=Vtilde0*Pfun
  η=0.1*Pfun
  σ=0.3*Pfun
  α=Pfun

  function CGLfunrealdevect(du,u,p3,t)
    Nx,D,η,g,V,α,σ=p3 
  
    X= @view u[:,:,1]
    P= @view u[:,:,2]
    dX= @view du[:,:,1]
    dP= @view du[:,:,2]
      
    @inbounds for kk in 2:Nx-1, jj in 2:Nx-1  
        dX[jj,kk]=D*η[jj,kk]*(X[jj-1,kk]+X[jj+1,kk]+X[jj,kk-1]+X[jj,kk+1]-4*X[jj,kk])-D*(P[jj-1,kk]+P[jj+1,kk]+P[jj,kk-1]+P[jj,kk+1]-4*P[jj,kk]) +
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
    end


    @inbounds for kk in 2:Nx-1,jj in 2:Nx-1  
        dP[jj,kk]=D*η[jj,kk]*(P[jj-1,kk]+P[jj+1,kk]+P[jj,kk-1]+P[jj,kk+1]-4*P[jj,kk])+D*(X[jj-1,kk]+X[jj+1,kk]+X[jj,kk-1]+X[jj,kk+1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
    end

    @inbounds for jj in 2:Nx-1
        kk=1
        dX[jj,kk]=D*η[jj,kk]*(X[jj-1,kk]+X[jj+1,kk]+2*X[jj,kk+1]-4*X[jj,kk])-D*(P[jj-1,kk]+P[jj+1,kk]+2*P[jj,kk+1]-4*P[jj,kk])+
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
    end


    @inbounds for jj in 2:Nx-1
        kk=1
        dP[jj,kk]=D*η[jj,kk]*(P[jj-1,kk]+P[jj+1,kk]+2*P[jj,kk+1]-4*P[jj,kk])+D*(X[jj-1,kk]+X[jj+1,kk]+2*X[jj,kk+1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
    end

    @inbounds for jj in 2:Nx-1
        kk=Nx
        dX[jj,kk]=D*η[jj,kk]*(X[jj-1,kk]+X[jj+1,kk]+2*X[jj,kk-1]-4*X[jj,kk])-D*(P[jj-1,kk]+P[jj+1,kk]+2*P[jj,kk-1]-4*P[jj,kk])+
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
    end


    @inbounds for jj in 2:Nx-1
        kk=Nx
        dP[jj,kk]=D*η[jj,kk]*(P[jj-1,kk]+P[jj+1,kk]+2*P[jj,kk-1]-4*P[jj,kk])+D*(X[jj-1,kk]+X[jj+1,kk]+2*X[jj,kk-1]-4*X[jj,kk])+
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
    end

    @inbounds for kk in 2:Nx-1 
        jj=1
        dX[jj,kk]=D*η[jj,kk]*(2*X[jj+1,kk]+X[jj,kk-1]+X[jj,kk+1]-4*X[jj,kk])-D*(2*P[jj+1,kk]+P[jj,kk-1]+P[jj,kk+1]-4*P[jj,kk]) +
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
    end


    @inbounds for kk in 2:Nx-1 
        jj=1
        dP[jj,kk]=D*η[jj,kk]*(2*P[jj+1,kk]+P[jj,kk-1]+P[jj,kk+1]-4*P[jj,kk])+D*(2*X[jj+1,kk]+X[jj,kk-1]+X[jj,kk+1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
    end

    @inbounds for kk in 2:Nx-1 
        jj=Nx
        dX[jj,kk]=D*η[jj,kk]*(2*X[jj-1,kk]+X[jj,kk-1]+X[jj,kk+1]-4*X[jj,kk])-D*(2*P[jj-1,kk]+P[jj,kk-1]+P[jj,kk+1]-4*P[jj,kk]) +
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
    end

    @inbounds for kk in 2:Nx-1 
        jj=Nx
        dP[jj,kk]=D*η[jj,kk]*(2*P[jj-1,kk]+P[jj,kk-1]+P[jj,kk+1]-4*P[jj,kk])+D*(2*X[jj-1,kk]+X[jj,kk-1]+X[jj,kk+1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
    end

    @inbounds begin
        jj=1; kk=1
        dX[jj,kk]=D*η[jj,kk]*(2*X[jj+1,kk]+2*X[jj,kk+1]-4*X[jj,kk])-D*(2*P[jj+1,kk]+2*P[jj,kk+1]-4*P[jj,kk]) +
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
        dP[jj,kk]=D*η[jj,kk]*(2*P[jj+1,kk]+2*P[jj,kk+1]-4*P[jj,kk])+D*(2*X[jj+1,kk]+2*X[jj,kk+1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);

        jj=1; kk=Nx
        dX[jj,kk]=D*η[jj,kk]*(2*X[jj+1,kk]+2*X[jj,kk-1]-4*X[jj,kk])-D*(2*P[jj+1,kk]+2*P[jj,kk-1]-4*P[jj,kk])+
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
        dP[jj,kk]=D*η[jj,kk]*(2*P[jj+1,kk]+2*P[jj,kk-1]-4*P[jj,kk])+D*(2*X[jj+1,kk]+2*X[jj,kk-1]-4*X[jj,kk])+
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);

        jj=Nx; kk=1
        dX[jj,kk]=D*η[jj,kk]*(2*X[jj-1,kk]+2*X[jj,kk+1]-4*X[jj,kk])-D*(2*P[jj-1,kk]+2*P[jj,kk+1]-4*P[jj,kk]) +
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
        dP[jj,kk]=D*η[jj,kk]*(2*P[jj-1,kk]+2*P[jj,kk+1]-4*P[jj,kk])+D*(2*X[jj-1,kk]+2*X[jj,kk+1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
        
        jj=Nx; kk=Nx
        dX[jj,kk]=D*η[jj,kk]*(2*X[jj-1,kk]+2*X[jj,kk-1]-4*X[jj,kk])-D*(2*P[jj-1,kk]+2*P[jj,kk-1]-4*P[jj,kk])+
        α[jj,kk]*X[jj,kk]+V[jj,kk]*P[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*X[jj,kk]+g*P[jj,kk]);
        dP[jj,kk]=D*η[jj,kk]*(2*P[jj-1,kk]+2*P[jj,kk-1]-4*P[jj,kk])+D*(2*X[jj-1,kk]+2*X[jj,kk-1]-4*X[jj,kk]) +
        α[jj,kk]*P[jj,kk]-V[jj,kk]*X[jj,kk]+(X[jj,kk]^2+P[jj,kk]^2)*(-σ[jj,kk]*P[jj,kk]-g*X[jj,kk]);
    end
  end        
  CGLfunrealdevect
end

CGLfunrealdevect=mkfun()


function solveit()
  u0=1e-3*randn(Nx,Nx,2);

  D=1/gridsize^2;
  p3=(Nx,D,η,g,V,α,σ)

  prob=ODEProblem(CGLfunrealdevect,u0,(0,100.),p3)


  sol=solve(prob,Vern7(),saveat=tarray); 
  sol
end