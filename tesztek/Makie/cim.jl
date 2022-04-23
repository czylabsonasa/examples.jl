using CImGui
include(joinpath(pathof(CImGui), "..", "..", "examples", "Renderer.jl"))
using .Renderer

arr = Cfloat[sin(x) for x in 0:0.01:2pi];

function ui(arr)
    CImGui.Begin("Hello ImGui")
        CImGui.PlotLines("sine wave", arr, length(arr))
    CImGui.End()
end

Renderer.render(()->ui(arr), width = 360, height = 480, title = "A simple UI")
