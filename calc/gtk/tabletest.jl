using Gtk

win = GtkWindow("Table test",500,500)

tbl = GtkGrid()
tbl[1,1] = GtkButton("11")
tbl[1,2] = GtkButton("12")
tbl[2,1] = GtkButton("21")
tbl[2,2] = GtkButton("22")

set_gtk_property!(tbl, :row_spacing, 10)
set_gtk_property!(tbl, :column_spacing, 10)
set_gtk_property!(tbl[1,1], :expand, true)
set_gtk_property!(tbl[1,2], :expand, true)
set_gtk_property!(tbl[2,1], :expand, true)
set_gtk_property!(tbl[2,2], :expand, true)


push!(win, tbl)

showall(win)
