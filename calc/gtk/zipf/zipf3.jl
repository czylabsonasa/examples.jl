#
# zipf3.jl
#
#
# 
# 

# @kwarg mutable struct Params
  # data::Array{String}
  # x::Array{Float64}
  # y::Array{Float64}
# end


function zipf3(ny=2)  
  debug("zipf3")
  elem = Dict(
    "add" => GtkButton("add"),
    "quit" => GtkButton("quit"),
    "hsep" => GtkSeparatorToolItem(),
  )


  succ = mksucc(ny)
  sx,sy = 0,ny

  topW = GtkWindow("top", 800, 600)

  topG = GtkGrid()

  workG = GtkGrid()

  topG[1,1] = elem["add"]
  topG[2,1] = elem["hsep"]
  topG[3,1] = elem["quit"]
  topG[2,2] = workG
  push!(topW, topG)

  set_gtk_property!(elem["hsep"], :hexpand, true)
  set_gtk_property!(workG, :expand, true)
  

  function mkadd()
    debug("mkadd")

    plt = nothing
    pltC = GtkCanvas()
    openB = GtkButton("open")
    locG = GtkGrid()
    locG[1, 1] = openB
    locG[2, 2] = pltC

    workG[sx, sy] = GtkFrame("$(sx),$(sy)")
    push!(workG[sx, sy], locG)

    set_gtk_property!(workG[sx, sy], :expand, true)
    set_gtk_property!(pltC, :expand, true) # expand: must be a child?...


    openH = signal_connect(openB, :clicked) do widget
      debug("openH")
      fname = open_dialog("choose a text file")
      data = read_data(fname)
      x,y = compute(data)
      title = map(c->c=='_' ? ' ' : c, split(fname,"/")|>last)
      plt = plot(x, y, "r.", title = title)
      display(pltC, plt)
      showall(topW)
    end
  end
  

  addH = signal_connect(elem["add"], :clicked) do widget
    debug("addH")
    sx, sy = succ(sx, sy)

    mkadd()

    showall(topW)
  end

  quitH = signal_connect(elem["quit"], :clicked) do widget
    debug("quitH")
    destroy(topW)
  end

  showall(topW)
end
