#
# zipf2.jl
#
#
# win < (dynamic) grid < frame < canvas < mouse button press (open+new element)
#

function zipf2(ny=2)  
  debug("zipf2")

  succ = mksucc(ny)
  sx,sy = 1,1

  top = GtkWindow("main", 800, 600)

  grd = GtkGrid()

  function mkwdg()
    debug("mkwdg")
    c = GtkCanvas()

    c.mouse.button3press = @guarded (widget, event) -> begin
      debug("button3press")
      fname = open_dialog("open file")
      data = read_data(fname)
      x,y = compute(data)

      title = map(x->x=='_' ? ' ' : x, split(fname,"/")|>last)
      p = plot(x, y, "r.", title=title)
      display(c, p)
      showall(top)
    end
    
    c.mouse.button2press = @guarded (widget, event) -> begin
      debug("button2press")
      sx, sy = succ(sx, sy)
      delete!(top, grd)
      grd[sx,sy] = mkwdg()
      push!(top, grd)
      showall(top)
    end

    f=GtkFrame(c,"$(sx),$(sy)")
    set_gtk_property!(f, :expand, true)
    f
  end

  grd[sx,sy] = mkwdg()


  push!(top, grd)

  showall(top)
end
