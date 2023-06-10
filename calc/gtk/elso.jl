using Gtk

win = GtkWindow("My First Gtk.jl Program", 400, 200)

b = GtkButton("Click Me")
push!(win,b)

function my_handler()
  println("The button has been clicked")
end


signal_connect(b->my_handler(), b, "clicked")

showall(win)