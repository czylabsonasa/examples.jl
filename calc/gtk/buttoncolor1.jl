# change the color according to an event

using Gtk 

let

  win = GtkWindow("ButtonColorTest 1")

  butt = GtkButton("")
  sc = GAccessor.style_context(butt)

  blue = GtkCssProvider(data="#blue {background:blue;}")
  yellow = GtkCssProvider(data="#yellow {background:yellow;}")


  spb = GtkStyleProvider(blue)
  spy = GtkStyleProvider(yellow)
  push!(sc, spb, 600)

  set_gtk_property!(butt, :name, "blue")

  clickhandler = signal_connect(butt, :clicked) do widget
    if get_gtk_property(widget, :name, String) == "blue"
      push!(sc, spy, 600)
      set_gtk_property!(butt, :name, "yellow")
    else
      push!(sc, spb, 600)
      set_gtk_property!(butt, :name, "blue")
    end
  end


  push!(win, butt)
  showall(win)

end
