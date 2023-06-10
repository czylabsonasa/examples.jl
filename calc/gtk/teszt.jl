using Gtk
using Gtk.ShortNames, Gtk.GConstants, Gtk.Graphics
import Gtk.deleteat!, Gtk.libgtk_version, Gtk.GtkToolbarStyle, Gtk.GtkFileChooserAction, Gtk.GtkResponseType


contrast = MenuItem("Adjust contrast...")
popupmenu = Menu()
push!(popupmenu, contrast)
#c = Canvas()
win = Window("Popup")|>showall
showall(popupmenu)
win.mouse.button3press = (widget,event) -> popup(popupmenu, event)