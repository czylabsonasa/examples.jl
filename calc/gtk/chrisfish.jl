using Gtk, Gtk.ShortNames

w = Window("")

button = GtkButton("")

sc = Gtk.GAccessor.style_context(button)

pr = CssProviderLeaf(data="#green_button {background:green;}")

push!(sc, StyleProvider(pr), 600)

set_gtk_property!(button, :name, "green_button")

push!(w, button)

Gtk.showall(w)