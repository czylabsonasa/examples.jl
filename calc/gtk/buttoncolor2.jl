using Gtk 

let
  kol = ["red", "green", "blue", "yellow"]
  nextkol = Dict(
    kol[i]=>if i<length(kol) kol[i+1] else kol[1] end for i in 1:length(kol)
  )

  win = GtkWindow("ButtonColorTest 2")

  butt = GtkButton("")
  sc = Gtk.GAccessor.style_context(butt)


  sp = Dict(
    k=>GtkStyleProvider(GtkCssProvider(data="#$(k) {background:$(k);}")) for k in kol
  )

  inikol = rand(kol)
  push!(sc, sp[inikol], 600)

  set_gtk_property!(butt, :name, inikol)

  clickhandler = signal_connect(butt, "clicked") do widget
    akol = get_gtk_property(widget, :name, String)
    nkol = nextkol[akol]
    push!(sc, sp[nkol], 600)
    set_gtk_property!(butt, :name, nkol)
  end


  push!(win, butt)
  showall(win)

end
