# binarization + slider
# mod of main0.jl
### GtkScale -> slider

using
  #GtkReactive,
  Gtk, 
  TestImages, 
  ImageView
  
#im = testimage("lena_gray")
# im = load("data/lena1.tif")
im = testimage("cameraman")


(nx, ny) = size(im)


slid = GtkScale(false, 0.1:0.02:0.9)
set_gtk_property!(slid, :hexpand, true)
gas = GAccessor.adjustment(slid)
value = 0.5
set_gtk_property!(gas, :value, 0.5)


can1 = GtkCanvas()
set_gtk_property!(can1, :expand, true)
can2 = GtkCanvas()
set_gtk_property!(can2, :expand, true)



cutter(x,val)=x>val ? 1.0 : 0.0


gr = GtkGrid()
gr[2,1]=slid
gr[1,2]=can1
gr[2,2]=can2



win = GtkWindow("asd",2*512,512)
push!(win, gr)



imshow!(can1, im)
imshow!(can2, cutter.(im, value))

signal_connect(slid, :value_changed) do _
  value = get_gtk_property(gas, :value, Float64)
  imshow!(can2, cutter.(im, value))
  showall(win)
end


showall(win)
