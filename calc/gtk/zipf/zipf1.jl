#
# zipf1.jl
#
#
# win < box < frame < button (open, quit, separator); canvas
#



function zipf1()  
  data = nothing
  elem = Dict(
    "open" => GtkButton("open"),
    "quit" => GtkButton("quit"),
    "hsep" => GtkSeparatorToolItem(),
    "canvas" => GtkCanvas(),
  )

  topW = GtkWindow("Top",800,600)
  pltF = GtkFrame("Plot")
  ctrF = GtkFrame("Controls")
  hB = GtkBox(:h)
  vB = GtkBox(:v)


  push!(hB, elem["open"], elem["hsep"], elem["quit"])
  push!(ctrF, hB)
  push!(pltF, elem["canvas"])
  push!(vB, ctrF, pltF)
  push!(topW, vB)

  

  set_gtk_property!(pltF, :expand, true)
  set_gtk_property!(elem["hsep"], :hexpand, true)


  openH = signal_connect(elem["open"], :clicked) do widget
    fname = open_dialog("choose a file to be processed")
    data = read_data(fname)
    x,y = compute(data)
    p = plot(x, y, "r.")
    display(elem["canvas"], p)
  end

  quitH = signal_connect(elem["quit"], :clicked) do widget
    destroy(topW)
  end


  showall(topW)
end
