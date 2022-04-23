using 
  Interact, Blink, 
  Gadfly,
  Compose

set_default_plot_size(10cm, 10cm)
w = Window()

mp = 
  @manipulate for A in -5:0.1:5, B in -5:0.1:5, C in -5:0.1:5
    plot(
      x->A*x^2+B*x+C, 
      -10, 10, 
      Coord.cartesian(xmin=-10, xmax=10, ymin=-100, ymax=100)
    )
end

body!(
  w,
  mp
)
