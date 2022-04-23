# using MakieLayout, AbstractPlotting, GLMakie
# outer_padding = 30
# scene, layout = layoutscene(outer_padding, 
#                         resolution=(1200, 700), 
#                         backgroundcolor=RGBf0(0.98,0.98,0.98))
# ax1 = layout[1, 1] = LAxis(scene, title="hello1")
# ax2 = layout[1, 2] = LAxis(scene, title="hello2")

# linkaxes!(ax1, ax2)
# hideydecorations!(ax2, grid=false)
# display(scene)


using CairoMakie, LaTeXStrings

using Blink

# Makie.inline!(true)


f = Figure()
ax = Axis(f[1, 1])

lines!(
  0..10, 
  x -> sin(3x) / (cos(x) + 2),
  label = L"\frac{\sin(3x)}{\cos(x) + 2}"
)
lines!(
  0..10, 
  x -> sin(x^2) / (cos(sqrt(x)) + 2),
  label = L"\frac{\sin(x^2)}{\cos(\sqrt{x}) + 2}"
)

Legend(f[1, 2], ax)

body!(
  Window(), 
  f
)
