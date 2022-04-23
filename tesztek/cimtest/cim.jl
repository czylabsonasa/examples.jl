using CImGui
using CImGui.CSyntax
using CImGui.CSyntax.CStatic
using CImGui: ImVec2, ImVec4, IM_COL32, ImS32, ImU32, ImS64, ImU64

# include(joinpath(pathof(CImGui), "..", "..", "examples", "Renderer.jl"))
include("Renderer.jl")
# using .Renderer

#arr = Cfloat[sin(x) for x in 0:0.01:2pi];
function simpleUI()
  dom = Cfloat.(0:0.01:4pi)
  ldom = length(dom)
  arr = [
    sin.(dom), 
    sin.(dom)
  ]
  larr = length(arr)


  go_flag = fill(true, larr)

  function ui()
    CImGui.Begin("Hello ImGui")
    CImGui.PlotLines("fun 1", arr[1], ldom)
    CImGui.SameLine()
    @c CImGui.Checkbox("checkbox", &go_flag[1])

    CImGui.PlotLines("fun 2", arr[2], ldom)
    CImGui.End()
  end


  update(L=8)=( 
    for i in 1:larr
      if go_flag[i]
        tmp = arr[i][1:L];
        arr[i][1:ldom-L] .= arr[i][L+1:ldom];
        arr[i][ldom-L+1:ldom] .= tmp;
      end
    end      
  )

  function infinite_loop()
    @async while true
        update()
        yield()
    end
  end

  Renderer.render(()->ui(), width = 600, height = 400, title = "A simple UI")
  infinite_loop()

  sw(i)=go_flag[i] = !go_flag[i]
end
