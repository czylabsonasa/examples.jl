# quitting the gui keeps the infinite_loop fun alive

using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui: ImVec2, ImVec4, IM_COL32, ImS32, ImU32, ImS64, ImU64

include("Renderer.jl")

mutable struct mobj
  fun::Function
  val::Array{Float64}
  strength::Float32
  dend::Float32
  step::Float32
  go_flag::Bool
  name::String
end




function simpleUI()
  velo = Int32(10)

  step = 0.001
  dend = 2pi
  dom = collect(0:step:dend)
  ldom = length(dom)
  msum = similar(dom)

  fun1 = x->sin(x)
  obj1 = mobj(fun1, fun1.(dom), 1.0, dend, step, true, "sin")

  fun2 = x->sin(2.0*x)
  obj2 = mobj(fun2, fun2.(dom), 1.0, dend, step, true, "sin(2x)")
  
  fun3 = x->sin(3.0*x)
  obj3 = mobj(fun3, fun3.(dom), 1.0, dend, step, true, "sin(3x)")



  # println(obj1.val |> length)
  # println(obj2.val |> length)

  
  function ui()
    CImGui.Begin("Hello ImGui") ;

    @c CImGui.SliderInt("velocity", &velo, 0, 30) ;
    #@c CImGui.DragInt(, &velo, velo, 0, 500, "%d")

    CImGui.Separator() ;

    CImGui.PlotLines(obj1.name, Float32.(obj1.val), ldom) ;
    CImGui.SameLine() ;
    @c CImGui.InputFloat("strength1", &obj1.strength, 0.01, 1.0, "%.3f") ;
    # CImGui.SameLine() ;
    # @c CImGui.Checkbox("go1", &obj1.go_flag) ;

    CImGui.PlotLines(obj2.name, Cfloat.(obj2.val), ldom) ;
    CImGui.SameLine() ;
    @c CImGui.InputFloat("strength2", &obj2.strength, 0.01, 1.0, "%.3f") ;
    # CImGui.SameLine() ;
    # @c CImGui.Checkbox("go2", &obj2.go_flag) ;

    CImGui.PlotLines(obj3.name, Cfloat.(obj3.val), ldom) ;
    CImGui.SameLine() ;
    @c CImGui.InputFloat("strength3", &obj3.strength, 0.01, 0.1, "%.3f") ;
    # CImGui.SameLine() ;
    # @c CImGui.Checkbox("go3", &obj3.go_flag) ;

    CImGui.Separator()

    cmax = sum( abs.([obj1.strength,obj2.strength,obj3.strength]))
    CImGui.PlotLines("sum", Cfloat.(msum), ldom, 0, "", -cmax,cmax,ImVec2(0,200)) ;
    #CImGui.SameLine()


    CImGui.End()
  end


  update(obj)=(
    if obj.strength != 0.0
      v = 10 * velo #
      obj.val[1:end-v] .= obj.val[v+1:end];
      step = obj.step
      dend = obj.dend
      obj.dend = dend+v*step
      obj.val[end-v+1:end] .= obj.fun.(range(dend+step,obj.dend,length=v))
      1
    else
      0
    end
  )

  update()=begin
    t=update(obj1)+update(obj2)+update(obj3)
    if t>0
      msum .= 0.0
      msum .+= obj1.strength*obj1.val
      msum .+= obj2.strength*obj2.val
      msum .+= obj3.strength*obj3.val
    end
  end
  

  function infinite_loop()
    @async while true==onrender
        update() 
        yield()
        #sleep(0.001)
    end
  end

  t=render(()->ui(), width = 600, height = 400, title = "A simple UI")
  typeof(t) |> show
  infinite_loop()

end
