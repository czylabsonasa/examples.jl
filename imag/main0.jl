# binarization + slider

import 
  Images as IM, 
  ImageView as IMV,
  GtkReactive as GTR

using
  Gtk, 
  TestImages
  
im = testimage("lena_gray")

# im = IM.load("data/lena1.tif")
size(im) |> println

gr = GtkGrid()

slid = GtkScale(false, 0.1:0.02:0.9)
set_gtk_property!(slid, :hexpand, true)
gas = GAccessor.adjustment(slid)
value = 0.5
set_gtk_property!(gas, :value, 0.5)


can = GTR.canvas()
set_gtk_property!(can, :expand, true)
# fr = GtkFrame()
# push!(fr, can)
# set_gtk_property!(fr, :expand, true)



cutter(x,val)=x>val ? 1.0 : 0.0



vb = GtkBox(:v)
push!(vb, slid, can)


win = GtkWindow("asd",512,512)
push!(win, vb)




IMV.imshow!(can, cutter.(im, value))

signal_connect(slid, :value_changed) do _
  value = get_gtk_property(gas, :value, Float64)
  IMV.imshow!(can, cutter.(im, value))
  Gtk.showall(win)
end

showall(win)
