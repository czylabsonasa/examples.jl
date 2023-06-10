using Gtk 

let
  win = GtkWindow("LightOut")

  nx, ny = 4,4

  A = GtkCssProvider(data="#A {background:darkblue;}")
  B = GtkCssProvider(data="#B {background:yellow;}")

  sp = Dict("A"=>GtkStyleProvider(A), "B"=>GtkStyleProvider(B))


  butt = GtkButtonLeaf.(fill("",nx, ny))
  sc = Gtk.GAccessor.style_context.(butt)

  grd = GtkGrid()
  for x in 1:nx, y in 1:ny
    grd[x,y] = butt[x,y]
    akt = rand(["A","B"])
    push!(sc[x,y], sp[akt], 600)
    set_gtk_property!(grd[x,y], :name, akt)
    set_gtk_property!(grd[x,y], :expand, true)
  end

  function chgcolor(x,y)
    if get_gtk_property(grd[x,y], :name, String) == "A"
      push!(sc[x,y], sp["B"], 600)
      set_gtk_property!(grd[x,y], :name, "B")
    else
      push!(sc[x,y], sp["A"], 600)
      set_gtk_property!(grd[x,y], :name, "A")
    end
  end
  
  function handler(x,y)
    chgcolor(x,y)
    (x+1<=nx)&&chgcolor(x+1,y)
    (x-1>=1)&&chgcolor(x-1,y)
    (y+1<=ny)&&chgcolor(x,y+1)
    (y-1>=1)&&chgcolor(x,y-1)
  end

  for x in 1:nx, y in 1:ny
    signal_connect(w->handler(x,y), grd[x,y], "clicked")
  end

  push!(win, grd)

  showall(win)
end
